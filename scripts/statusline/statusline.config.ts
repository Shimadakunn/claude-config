export interface StatuslineConfig {
	oneLine: boolean;
	pathDisplayMode: "full";
	separator: "•";
	session: {
		showTokens: boolean;
		showPercentage: boolean;
		showModel: boolean;
		showFiveHourUsage: boolean;
		showSevenDayUsage: boolean;
	};
	context: {
		maxContextTokens: 200000;
	};
}

export const defaultConfig: StatuslineConfig = {
	oneLine: true,
	pathDisplayMode: "full",
	separator: "•",
	session: {
		showTokens: true,
		showPercentage: true,
		showModel: true,
		showFiveHourUsage: true,
		showSevenDayUsage: true,
	},
	context: {
		maxContextTokens: 200000,
	},
};
