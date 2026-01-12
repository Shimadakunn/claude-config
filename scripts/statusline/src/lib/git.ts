import { $ } from "bun";

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
