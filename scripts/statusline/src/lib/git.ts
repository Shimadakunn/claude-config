import { $ } from "bun";
import { resolve } from "node:path";

export async function getBranchName(): Promise<string | null> {
	try {
		const result = await $`git rev-parse --abbrev-ref HEAD`.text();
		return result.trim() || null;
	} catch {
		return null;
	}
}

export async function hasUncommittedChanges(): Promise<boolean> {
	try {
		const result = await $`git status --porcelain`.text();
		return result.trim().length > 0;
	} catch {
		return false;
	}
}

export async function isWorktree(): Promise<boolean> {
	try {
		const gitDir = resolve((await $`git rev-parse --git-dir`.text()).trim());
		const gitCommonDir = resolve((await $`git rev-parse --git-common-dir`.text()).trim());
		return gitDir !== gitCommonDir;
	} catch {
		return false;
	}
}

export async function hasWorktrees(): Promise<boolean> {
	try {
		const result = await $`git worktree list`.text();
		const lines = result.trim().split("\n").filter(Boolean);
		return lines.length > 1;
	} catch {
		return false;
	}
}
