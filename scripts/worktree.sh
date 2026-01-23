#!/bin/bash

# Worktree Manager - A CLI tool for managing git worktrees
# Usage:
#   wk           - Interactive selection to open a worktree in Cursor
#   wk -c <branch> - Create a worktree for the given branch
#   wk -d [branch] - Delete a worktree (interactive if no branch specified)
#
# Can be sourced in .zshrc or .bashrc, or executed directly.

# Ensure essential paths are available (especially important when sourced early in shell init)
[[ ":$PATH:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:$PATH"
[[ ":$PATH:" != *":/usr/bin:"* ]] && export PATH="/usr/bin:$PATH"
[[ ":$PATH:" != *":/opt/homebrew/bin:"* ]] && export PATH="/opt/homebrew/bin:$PATH"

# Detect if script is being sourced (for proper exit handling)
_worktree_sourced=0
if [[ "${BASH_SOURCE[0]}" != "${0}" ]] 2>/dev/null || [[ "$ZSH_EVAL_CONTEXT" =~ :file$ ]] 2>/dev/null; then
    _worktree_sourced=1
fi

# Colors for output
_WT__WT_RED='\033[0;31m'
_WT__WT_GREEN='\033[0;32m'
_WT__WT_YELLOW='\033[0;33m'
_WT__WT_BLUE='\033[0;34m'
_WT__WT_NC='\033[0m' # No Color

# City names for random worktree directories
_WT_CITIES=(
    paris london tokyo berlin rome madrid amsterdam vienna prague stockholm
    oslo dublin lisbon athens brussels budapest warsaw helsinki copenhagen zurich
    barcelona milan munich venice florence naples lyon marseille nice bordeaux
    seoul beijing shanghai singapore sydney melbourne auckland toronto vancouver
    chicago boston seattle denver phoenix portland austin miami houston dallas
    cairo mumbai delhi dubai istanbul moscow kyoto osaka hanoi bangkok jakarta
    lima bogota santiago havana panama quito caracas montevideo buenosaires
    lagos nairobi casablanca tunis algiers accra dakar kampala addisababa
    reykjavik tallinn riga vilnius minsk belgrade sofia bucharest zagreb
)

# Exit function that works for both sourced and executed scripts
_worktree_exit() {
    local code="${1:-0}"
    if [[ $_worktree_sourced -eq 1 ]]; then
        return "$code" 2>/dev/null || true
    else
        exit "$code"
    fi
}

# Error handler for better debugging
_worktree_error() {
    local message="${1:-Unknown error}"
    local code="${2:-1}"
    echo -e "${_WT_RED}Error: ${message}${_WT_NC}" >&2
    _worktree_exit "$code"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir &>/dev/null; then
        _worktree_error "Not in a git repository. Please cd into a git project first."
    fi
}

# Check if fzf is installed
check_fzf() {
    if ! command -v fzf &>/dev/null; then
        echo -e "${_WT_RED}Error: fzf is required but not installed.${_WT_NC}" >&2
        echo "Install with: brew install fzf" >&2
        _worktree_exit 1
        return 1
    fi
}

# Copy .env* files from main repo to worktree (only gitignored ones)
copy_env_files() {
    local source_dir="$1"
    local target_dir="$2"

    local env_files
    env_files=$(find "$source_dir" -name ".env*" -type f ! -path "*/worktree/*" ! -path "*/.git/*" ! -path "*/node_modules/*" 2>/dev/null)

    if [[ -z "$env_files" ]]; then
        return 0
    fi

    local copied=0
    while IFS= read -r env_file; do
        # Only copy files that are gitignored (tracked files already exist in worktree)
        if ! git -C "$source_dir" check-ignore -q "$env_file" 2>/dev/null; then
            continue
        fi

        local relative_path="${env_file#$source_dir/}"
        local target_path="$target_dir/$relative_path"
        local target_parent
        target_parent=$(dirname "$target_path")

        mkdir -p "$target_parent" 2>/dev/null
        if cp "$env_file" "$target_path" 2>/dev/null; then
            ((copied++))
        fi
    done <<< "$env_files"

    if [[ $copied -gt 0 ]]; then
        echo -e "${_WT_GREEN}Copied $copied .env* file(s) to worktree${_WT_NC}"
    fi
}

# Get a random city name that isn't already used in the worktree directory
get_random_city() {
    local worktree_dir="$1"
    local max_attempts=100
    local attempt=0

    while [[ $attempt -lt $max_attempts ]]; do
        local index=$((RANDOM % ${#_WT_CITIES[@]}))
        local city="${_WT_CITIES[$index]}"

        if [[ ! -d "$worktree_dir/$city" ]]; then
            echo "$city"
            return 0
        fi
        ((attempt++))
    done

    # Fallback: use timestamp if all cities are taken
    echo "worktree-$(date +%s)"
}

# Get the main repository root (not the worktree root)
# Uses git worktree list to ensure path matches exactly what git outputs
get_main_repo_root() {
    git worktree list --porcelain | awk '/^worktree / { print substr($0, 10); exit }'
}

# List all worktrees in a formatted way for fzf (excludes main repo)
list_worktrees() {
    # First worktree entry is always the base repo - skip it
    git worktree list --porcelain | awk '
        /^worktree / {
            path = substr($0, 10)
            if (first_path == "") first_path = path
        }
        /^branch / { branch = substr($0, 8); gsub("refs/heads/", "", branch) }
        /^HEAD / { head = substr($0, 6) }
        /^$/ {
            if (path != first_path) {
                if (branch != "") {
                    print branch "\t" path
                } else if (head != "") {
                    print "(detached: " substr(head, 1, 7) ")\t" path
                }
            }
            branch = ""; head = ""; path = ""
        }
        END {
            if (path != "" && path != first_path) {
                if (branch != "") {
                    print branch "\t" path
                } else if (head != "") {
                    print "(detached: " substr(head, 1, 7) ")\t" path
                }
            }
        }
    '
}

# Change to worktree directory
goto_worktree() {
    local path="$1"

    if [[ ! -d "$path" ]]; then
        _worktree_error "Directory does not exist: $path"
    fi

    # Convert to absolute path
    local abs_path
    abs_path=$(cd "$path" && pwd) || _worktree_error "Failed to resolve path: $path"

    echo -e "${_WT_GREEN}Changing to ${_WT_BLUE}$abs_path${_WT_NC}"
    cd "$abs_path" || _worktree_error "Failed to cd to: $abs_path"
}

# Interactive worktree selection with mode cycling (Tab to switch modes)
# Usage: select_worktree [initial_mode]
#   initial_mode: "select" (default), "create", or "delete"
select_worktree() {
    local initial_mode="${1:-select}"
    check_fzf

    # Capture full paths to commands (zsh loses PATH context in some cases)
    local FZF_CMD GIT_CMD
    FZF_CMD="$(command -v fzf)"
    GIT_CMD="$(command -v git)"

    local worktrees
    worktrees=$(list_worktrees)

    # Create temp files for mode tracking and helper scripts
    local temp_dir
    temp_dir=$(mktemp -d)
    local mode_file="$temp_dir/mode"
    local cycle_script="$temp_dir/cycle.sh"
    local content_script="$temp_dir/content.sh"
    local header_script="$temp_dir/header.sh"

    # Cleanup function
    _wt_cleanup() {
        rm -rf "$temp_dir" 2>/dev/null
    }

    echo "$initial_mode" > "$mode_file"

    # Calculate dynamic height
    local worktree_count=0
    if [[ -n "$worktrees" ]]; then
        worktree_count=$(echo "$worktrees" | wc -l | tr -d ' ')
    fi
    local height=$((worktree_count > 0 ? worktree_count + 9 + 6 : 16))

    # Write cycle script - cycles mode AND outputs new header for transform-header
    cat > "$cycle_script" << 'CYCLE_EOF'
#!/bin/bash
mode_file="$1"
mode=$(cat "$mode_file")
case $mode in
    select) echo "create" > "$mode_file" ;;
    create) echo "delete" > "$mode_file" ;;
    delete) echo "select" > "$mode_file" ;;
esac
CYCLE_EOF
    chmod +x "$cycle_script"

    # Write content script to temp file (receives mode_file as arg)
    cat > "$content_script" << 'CONTENT_EOF'
#!/bin/bash
mode=$(cat "$1")
if [ "$mode" = "create" ]; then
    git branch -r 2>/dev/null | grep -v HEAD | sed 's/origin\///' | sed 's/^[[:space:]]*//' | sort -u
else
    # Get main repo from first worktree entry (always the base repo)
    # Then skip the first entry when listing
    git worktree list --porcelain | awk '
        /^worktree / {
            path = substr($0, 10)
            if (first_path == "") first_path = path
        }
        /^branch / { branch = substr($0, 8); gsub("refs/heads/", "", branch) }
        /^HEAD / { head = substr($0, 6) }
        /^$/ {
            if (path != first_path) {
                if (branch != "") { print branch "\t" path }
                else if (head != "") { print "(detached: " substr(head, 1, 7) ")\t" path }
            }
            branch = ""; head = ""; path = ""
        }
        END {
            if (path != "" && path != first_path) {
                if (branch != "") { print branch "\t" path }
                else if (head != "") { print "(detached: " substr(head, 1, 7) ")\t" path }
            }
        }
    '
fi
CONTENT_EOF
    chmod +x "$content_script"

    # Write header script to temp file (with ANSI colors)
    cat > "$header_script" << 'HEADER_EOF'
#!/bin/bash
mode=$(cat "$1")
# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'
case $mode in
    select) printf "${BOLD}${GREEN}[SELECT]${NC}  ${DIM}Create   Delete${NC}  | Tab: cycle | Esc: cancel" ;;
    create) printf "${DIM} Select ${NC} ${BOLD}${YELLOW}[CREATE]${NC}  ${DIM}Delete${NC}  | Tab: cycle | Esc: cancel" ;;
    delete) printf "${DIM} Select   Create ${NC} ${BOLD}${RED}[DELETE]${NC}  | Tab: cycle | Esc: cancel" ;;
esac
HEADER_EOF
    chmod +x "$header_script"

    local fzf_output
    local fzf_exit_code
    fzf_output=$("$content_script" "$mode_file" | "$FZF_CMD" \
        --delimiter='\t' \
        --with-nth=1 \
        --print-query \
        --preview="mode=\$(cat '$mode_file'); if [ \"\$mode\" = 'create' ]; then echo -e \"Mode: CREATE new worktree\n\nBranch: {1}\n\n\$(git log --oneline -5 origin/{1} 2>/dev/null || echo 'New branch (will be created)')\"; elif [ \"\$mode\" = 'delete' ]; then echo -e \"Mode: DELETE worktree\n\nPath: {2}\nBranch: {1}\n\n\$(git -C {2} status --short 2>/dev/null || echo 'Cannot get status')\"; else echo -e \"Path: {2}\n\nBranch: {1}\n\n\$(git -C {2} log --oneline -5 2>/dev/null || echo 'No commits')\"; fi" \
        --preview-window=top:9 \
        --header="$("$header_script" "$mode_file")" \
        --prompt="> " \
        --height="$height" \
        --border \
        --ansi \
        --bind="tab:execute-silent($cycle_script $mode_file)+reload($content_script $mode_file)+transform-header($header_script $mode_file)") || fzf_exit_code=$?

    # Get final mode
    local final_mode
    final_mode=$(cat "$mode_file")

    # Parse fzf output: line 1 = query, line 2 = selection
    local query selection
    query=$(echo "$fzf_output" | head -n 1)
    selection=$(echo "$fzf_output" | tail -n +2 | head -n 1)

    # Handle fzf exit codes (130 = Esc, 1 = no match but that's OK for create mode)
    if [[ ${fzf_exit_code:-0} -eq 130 ]]; then
        echo -e "${_WT_BLUE}Selection cancelled.${_WT_NC}"
        _wt_cleanup
        _worktree_exit 0
        return 0
    elif [[ ${fzf_exit_code:-0} -eq 1 ]]; then
        # Exit code 1 means no match - OK for create mode if we have a query
        if [[ "$final_mode" == "create" ]] && [[ -n "$query" ]]; then
            _wt_cleanup
            create_worktree "$query"
            return 0
        else
            echo -e "${_WT_BLUE}No selection made.${_WT_NC}"
            _wt_cleanup
            _worktree_exit 0
            return 0
        fi
    elif [[ ${fzf_exit_code:-0} -ne 0 ]]; then
        _wt_cleanup
        _worktree_error "fzf failed with exit code: ${fzf_exit_code}"
        return 1
    fi

    if [[ -n "$selection" ]]; then
        case "$final_mode" in
            select)
                local path="${selection#*$'\t'}"
                _wt_cleanup
                goto_worktree "$path"
                ;;
            create)
                # Selection is the branch name (could be from list or typed new)
                _wt_cleanup
                create_worktree "$selection"
                ;;
            delete)
                local branch="${selection%%$'\t'*}"
                local path="${selection#*$'\t'}"
                # Use fzf for confirmation to stay in TUI
                local confirm
                confirm=$(printf "Yes, delete\nNo, cancel" | "$FZF_CMD" \
                    --height=8 \
                    --reverse \
                    --border \
                    --header="Delete worktree '$branch'?" \
                    --prompt="> " \
                    --no-info \
                    --ansi) || confirm=""
                if [[ "$confirm" == "Yes, delete" ]]; then
                    if ! "$GIT_CMD" worktree remove "$path" --force 2>/dev/null; then
                        echo -e "${_WT_RED}Failed to remove worktree. Trying with force...${_WT_NC}"
                        /bin/rm -rf "$path"
                        "$GIT_CMD" worktree prune
                    fi
                    # Verify deletion succeeded
                    if [[ -d "$path" ]]; then
                        echo -e "${_WT_RED}Failed to delete worktree: $branch${_WT_NC}"
                    else
                        echo -e "${_WT_GREEN}Worktree deleted: $branch${_WT_NC}"
                    fi
                else
                    echo -e "${_WT_BLUE}Cancelled.${_WT_NC}"
                fi
                _wt_cleanup
                ;;
        esac
    else
        # No selection - but in create mode, use the query if available
        if [[ "$final_mode" == "create" ]] && [[ -n "$query" ]]; then
            _wt_cleanup
            create_worktree "$query"
        else
            echo -e "${_WT_BLUE}No selection made.${_WT_NC}"
            _wt_cleanup
        fi
    fi
}

# Create a new worktree
create_worktree() {
    local branch="$1"

    if [[ -z "$branch" ]]; then
        # Use unified interactive UI with create mode pre-selected
        select_worktree "create"
        return
    fi

    local main_repo
    main_repo=$(get_main_repo_root)

    # Determine worktree path - place it in ~/Documents/worktrees/<city>
    local worktree_dir="/Users/leo.combaret/Documents/worktrees"

    # Create worktree directory if it doesn't exist
    if [[ ! -d "$worktree_dir" ]]; then
        mkdir -p "$worktree_dir"
    fi

    # Check if a worktree for this branch already exists
    local existing_path
    existing_path=$(git worktree list --porcelain | awk -v branch="refs/heads/$branch" '
        /^worktree / { path = substr($0, 10) }
        /^branch / { b = substr($0, 8) }
        /^$/ || END { if (b == branch) { print path; exit } }
    ')

    if [[ -n "$existing_path" ]] && [[ -d "$existing_path" ]]; then
        echo -e "${_WT_YELLOW}Worktree for branch '$branch' already exists at: $existing_path${_WT_NC}"
        echo -e "Opening..."
        goto_worktree "$existing_path"
        return
    fi

    # Get a random city name for the worktree path
    local city_name
    city_name=$(get_random_city "$worktree_dir")
    local worktree_path="$worktree_dir/$city_name"

    # Check if branch exists locally or remotely
    if git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
        echo -e "${_WT_BLUE}Creating worktree from existing local branch: $branch${_WT_NC}"
        git worktree add "$worktree_path" "$branch"
    elif git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null; then
        echo -e "${_WT_BLUE}Creating worktree from remote branch: origin/$branch${_WT_NC}"
        git worktree add "$worktree_path" "$branch"
    elif git fetch origin "$branch" 2>/dev/null && git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null; then
        # Branch wasn't in local refs but exists on origin - fetch succeeded
        echo -e "${_WT_BLUE}Creating worktree from fetched remote branch: origin/$branch${_WT_NC}"
        git worktree add "$worktree_path" "$branch"
    else
        # Branch doesn't exist - let user choose base branch
        local FZF_CMD
        FZF_CMD="$(command -v fzf)"

        # Get list of local branches, with main/master at top
        local branches
        branches=$(git branch --format='%(refname:short)' | sort)

        # Detect main branch name (main or master)
        local default_branch="main"
        if git show-ref --verify --quiet "refs/heads/master" 2>/dev/null; then
            if ! git show-ref --verify --quiet "refs/heads/main" 2>/dev/null; then
                default_branch="master"
            fi
        fi

        # Show branch selection dialog
        local base_branch
        base_branch=$(echo "$branches" | "$FZF_CMD" \
            --height=20 \
            --reverse \
            --border \
            --header="Create '$branch' from which branch?" \
            --prompt="> " \
            --query="$default_branch" \
            --select-1 \
            --ansi) || base_branch=""

        if [[ -z "$base_branch" ]]; then
            echo -e "${_WT_BLUE}Cancelled.${_WT_NC}"
            return
        fi

        echo -e "${_WT_BLUE}Creating worktree with new branch: $branch (from $base_branch)${_WT_NC}"
        git worktree add -b "$branch" "$worktree_path" "$base_branch"
    fi

    # Copy .env* files from main repo to make worktree ready to use
    copy_env_files "$main_repo" "$worktree_path"

    echo -e "${_WT_GREEN}Worktree created: ${_WT_BLUE}$branch${_WT_GREEN} → ${_WT_YELLOW}$city_name${_WT_NC}"
    goto_worktree "$worktree_path"
}

# Delete a worktree
delete_worktree() {
    local branch="$1"

    if [[ -z "$branch" ]]; then
        # Use unified interactive UI with delete mode pre-selected
        select_worktree "delete"
    else
        # Delete specific branch worktree
        local worktree_path
        worktree_path=$(git worktree list --porcelain | awk -v branch="refs/heads/$branch" '
            /^worktree / { path = substr($0, 10) }
            /^branch / { b = substr($0, 8) }
            /^$/ || END {
                if (b == branch) { print path; exit }
            }
        ')

        if [[ -z "$worktree_path" ]]; then
            echo -e "${_WT_RED}Error: No worktree found for branch: $branch${_WT_NC}"
            _worktree_exit 1
            return 1
        fi

        echo -e "${_WT_YELLOW}Deleting worktree '$branch' at $worktree_path...${_WT_NC}"
        if ! command git worktree remove "$worktree_path" --force 2>/dev/null; then
            echo -e "${_WT_RED}Failed to remove worktree. Trying with force...${_WT_NC}"
            /bin/rm -rf "$worktree_path"
            command git worktree prune
        fi
        # Verify deletion succeeded
        if [[ -d "$worktree_path" ]]; then
            echo -e "${_WT_RED}Failed to delete worktree: $branch${_WT_NC}"
        else
            echo -e "${_WT_GREEN}Worktree deleted: $branch${_WT_NC}"
        fi
    fi
}

# Show usage
show_usage() {
    echo "Worktree Manager - A CLI tool for managing git worktrees"
    echo ""
    echo -e "${_WT_BLUE}Usage:${_WT_NC}"
    echo "  wk                        Interactive mode (Tab to cycle: Select/Create/Delete)"
    echo "  wk -c, --create [branch]  Create mode (interactive if no branch)"
    echo "  wk -d, --delete [branch]  Delete mode (interactive if no branch)"
    echo "  wk -h, --help             Show this help message"
    echo ""
    echo -e "${_WT_BLUE}Interactive Mode Keys:${_WT_NC}"
    echo "  Tab      Cycle between Select, Create, and Delete modes"
    echo "  Enter    Confirm selection in current mode"
    echo "  Esc      Cancel and exit"
    echo ""
    echo -e "${_WT_BLUE}Examples:${_WT_NC}"
    echo "  wk                   # Interactive mode starting in Select"
    echo "  wk -c                # Interactive mode starting in Create"
    echo "  wk -c feature/login  # Create worktree for feature/login branch directly"
    echo "  wk -d                # Interactive mode starting in Delete"
    echo "  wk -d feature/login  # Delete the feature/login worktree directly"
}

# Main entry point
_worktree_main() {
    # Check git first - required for all operations
    check_git_repo

    case "${1:-}" in
        -c|--create)
            create_worktree "$2"
            ;;
        -d|--delete)
            delete_worktree "$2"
            ;;
        -h|--help)
            show_usage
            ;;
        "")
            select_worktree
            ;;
        *)
            echo -e "${_WT_RED}Unknown option: $1${_WT_NC}" >&2
            echo "" >&2
            show_usage
            _worktree_exit 1
            return 1
            ;;
    esac
}

# Create the 'wk' command as a function (for when sourced)
wk() {
    _worktree_main "$@"
}

# Only auto-run if executed directly (not sourced)
if [[ $_worktree_sourced -eq 0 ]]; then
    # Trap errors for debugging (only when executed directly)
    trap 'echo -e "${_WT_RED}Script failed at line $LINENO${_WT_NC}" >&2' ERR
    _worktree_main "$@"
fi
