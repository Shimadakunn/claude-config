#!/usr/bin/env bun

import { defaultConfig } from "../statusline.config";
import { getContextData } from "./lib/context";
import {
  colors,
  formatModelName,
  formatPath,
  formatSession,
  formatTimeRemaining,
  formatUsagePercentage,
} from "./lib/formatters";
import type { HookInput } from "./lib/types";
import { getUsageLimits } from "./lib/usage-limits";
import { getBranchName, hasUncommittedChanges } from "./lib/git";

async function main() {
  try {
    const input: HookInput = await Bun.stdin.json();

    const dirPath = formatPath(
      input.workspace.current_dir,
      defaultConfig.pathDisplayMode
    );

    const branchName = await getBranchName();
    const hasChanges = await hasUncommittedChanges();

    const contextData = await getContextData({
      transcriptPath: input.transcript_path,
      maxContextTokens: defaultConfig.context.maxContextTokens,
    });

    const sessionInfo = formatSession(
      contextData.tokens,
      contextData.percentage,
      defaultConfig.session
    );

    const sep = ` ${colors.GRAY}${defaultConfig.separator}${colors.LIGHT_GRAY} `;
    const parts: string[] = [];

    const dirWithBranch = branchName
      ? `${dirPath}${colors.GRAY}(${branchName}${hasChanges ? `${colors.YELLOW}*${colors.GRAY}` : ""})${colors.LIGHT_GRAY}`
      : dirPath;
    parts.push(dirWithBranch);
    parts.push(sessionInfo);

    // Fetch usage limits
    const usageLimits = await getUsageLimits();

    if (
      usageLimits &&
      defaultConfig.session.showFiveHourUsage &&
      usageLimits.five_hour
    ) {
      const fiveHourPercent = formatUsagePercentage(
        usageLimits.five_hour.utilization
      );
      const fiveHourReset = usageLimits.five_hour.resets_at
        ? formatTimeRemaining(usageLimits.five_hour.resets_at)
        : "";
      const fiveHourStr = fiveHourReset
        ? `${fiveHourPercent}${colors.GRAY}%${colors.LIGHT_GRAY} ${colors.GRAY}${fiveHourReset}${colors.LIGHT_GRAY}`
        : `${fiveHourPercent}${colors.GRAY}%${colors.LIGHT_GRAY}`;
      parts.push(fiveHourStr);
    }

    if (
      usageLimits &&
      defaultConfig.session.showSevenDayUsage &&
      usageLimits.seven_day
    ) {
      const sevenDayPercent = formatUsagePercentage(
        usageLimits.seven_day.utilization
      );
      const sevenDayReset = usageLimits.seven_day.resets_at
        ? formatTimeRemaining(usageLimits.seven_day.resets_at)
        : "";
      const sevenDayStr = sevenDayReset
        ? `${sevenDayPercent}${colors.GRAY}%${colors.LIGHT_GRAY} ${colors.GRAY}${sevenDayReset}${colors.LIGHT_GRAY}`
        : `${sevenDayPercent}${colors.GRAY}%${colors.LIGHT_GRAY}`;
      parts.push(sevenDayStr);
    }
    if (defaultConfig.session.showModel)
      parts.push(formatModelName(input.model.display_name));

    console.log(`${colors.LIGHT_GRAY}${parts.join(sep)}${colors.RESET}`);
    console.log("");
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    console.log(
      `${colors.RED}Error:${colors.LIGHT_GRAY} ${errorMessage}${colors.RESET}`
    );
  }
}

main();
