import type { StatuslineConfig } from "../../statusline.config";

export const colors = {
  GRAY: "\x1b[0;90m",
  LIGHT_GRAY: "\x1b[0;37m",
  RESET: "\x1b[0m",
  YELLOW: "\x1b[0;33m",
  ORANGE: "\x1b[38;5;208m",
  RED: "\x1b[0;31m",
} as const;

export function formatPath(path: string, _mode: "full"): string {
  const lastSlash = path.lastIndexOf("/");
  return lastSlash !== -1 ? path.slice(lastSlash + 1) : path;
}

function formatTokens(tokens: number): string {
  if (tokens >= 1000000) {
    const value = Math.round(tokens / 1000000);
    return `${value}${colors.GRAY}m${colors.LIGHT_GRAY}`;
  }
  if (tokens >= 1000) {
    const value = Math.round(tokens / 1000);
    return `${value}${colors.GRAY}k${colors.LIGHT_GRAY}`;
  }
  return tokens.toString();
}

export function formatSession(
  tokens: number,
  percentage: number,
  config: StatuslineConfig["session"]
): string {
  const items: string[] = [];

  if (config.showTokens) {
    items.push(formatTokens(tokens));
  }
  if (config.showPercentage) {
    items.push(`${percentage}${colors.GRAY}%${colors.LIGHT_GRAY}`);
  }

  if (items.length === 0) {
    return "";
  }

  return `${colors.LIGHT_GRAY}${items.join(" ")}`;
}

export function formatTimeOnly(isoString: string): string {
  try {
    const date = new Date(isoString);
    return date.toLocaleTimeString("en-US", {
      hour: "numeric",
      minute: "2-digit",
      hour12: true,
    });
  } catch {
    return "";
  }
}

export function formatDateAndTime(isoString: string): string {
  try {
    const date = new Date(isoString);
    return (
      date.toLocaleDateString("en-US", {
        month: "short",
        day: "numeric",
      }) +
      " " +
      date.toLocaleTimeString("en-US", {
        hour: "numeric",
        minute: "2-digit",
        hour12: true,
      })
    );
  } catch {
    return "";
  }
}

export function formatTimeRemaining(isoString: string): string {
  try {
    const now = new Date();
    const resetTime = new Date(isoString);
    const diffMs = resetTime.getTime() - now.getTime();

    if (diffMs <= 0) return "0m";

    const days = Math.floor(diffMs / (1000 * 60 * 60 * 24));
    const hours = Math.floor(
      (diffMs % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
    );
    const minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));

    if (days > 0) {
      const roundedDays = hours >= 12 ? days + 1 : days;
      return `${roundedDays}d`;
    } else if (hours > 0) {
      const roundedHours = minutes >= 30 ? hours + 1 : hours;
      if (roundedHours === 24) {
        return "1d";
      }
      return `${roundedHours}h`;
    } else {
      return `${minutes}m`;
    }
  } catch {
    return "";
  }
}

export function formatUsagePercentage(utilization: number): string {
  return Math.round(utilization).toString();
}

export function formatModelName(displayName: string): string {
  const letter = displayName.split(" ")[0].toLowerCase();
  const lowerDisplay = displayName.toLowerCase();

  if (lowerDisplay.includes("haiku")) {
    return `${colors.YELLOW}${letter}${colors.LIGHT_GRAY}`;
  } else if (lowerDisplay.includes("sonnet")) {
    return `${colors.ORANGE}${letter}${colors.LIGHT_GRAY}`;
  } else if (lowerDisplay.includes("opus")) {
    return `${colors.RED}${letter}${colors.LIGHT_GRAY}`;
  }

  return letter;
}
