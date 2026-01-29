# Step 1: Fetch

Get unresolved review comments from the PR.

## API

Use GraphQL to get review threads with resolution status:

```bash
gh api graphql -f query='
  query($owner:String!,$repo:String!,$pr:Int!){
    repository(owner:$owner,name:$repo){
      pullRequest(number:$pr){
        reviewThreads(first:100){
          nodes{
            id
            isResolved
            comments(first:10){
              nodes{id,body,path,line,author{login},url}
            }
          }
        }
      }
    }
  }
' -f owner={owner} -f repo={repo} -F pr={pr_number}
```

Store both `thread_id` (GraphQL node ID for resolution) and `comment_id` (for reactions).

## Next

- No comments: stop
- `-all` flag: skip to `~/.claude/skills/fix-comments/references/3-display.md`
- Otherwise: read `~/.claude/skills/fix-comments/references/2-analyze.md`
