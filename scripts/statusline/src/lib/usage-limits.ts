import type { UsageLimits } from "./types";

async function getOAuthToken(): Promise<string | null> {
	try {
		// macOS: Get from keychain
		const result = await Bun.spawnSync([
			"security",
			"find-generic-password",
			"-a",
			process.env.USER || "",
			"-w",
			"-s",
			"Claude Code-credentials",
		]);

		if (result.success) {
			const output = new TextDecoder().decode(result.stdout).trim();
			const creds = JSON.parse(output);
			return creds.claudeAiOauth?.accessToken || null;
		}
	} catch {
		// Windows/Linux: Try file-based credentials
		try {
			const credPath = `${process.env.HOME}/.claude/.credentials.json`;
			const file = Bun.file(credPath);
			const creds = await file.json();
			return creds.claudeAiOauth?.accessToken || null;
		} catch {
			return null;
		}
	}

	return null;
}

async function fetchUsageLimits(token: string): Promise<UsageLimits | null> {
	try {
		const response = await fetch("https://api.anthropic.com/api/oauth/usage", {
			method: "GET",
			headers: {
				Accept: "application/json, text/plain, */*",
				"Content-Type": "application/json",
				"User-Agent": "claude-code/2.0.31",
				Authorization: `Bearer ${token}`,
				"anthropic-beta": "oauth-2025-04-20",
			},
		});

		if (!response.ok) return null;

		const data = await response.json();

		return {
			five_hour: data.five_hour || null,
			seven_day: data.seven_day || null,
		};
	} catch {
		return null;
	}
}

export async function getUsageLimits(): Promise<UsageLimits | null> {
	const token = await getOAuthToken();
	if (!token) return null;

	return await fetchUsageLimits(token);
}
