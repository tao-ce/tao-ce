from locust.shape import LoadTestShape
import utils.distribution as dst
from config import TestingConfig, profiles

mappize = lambda m, n : {k: v for k, v in [(x[n], x) for x in m]}

class CustomLoadTestShape(LoadTestShape):
    def build_distribution(self):
        self.distribution = dict(
            normal = dst.normal(self.ramp_mu_ratio, self.ramp_sigma),
            linear = dst.linear(),
            instant = dst.instant(),
            exponential = dst.exponential(),
        )[self.ramp_method](self.users_count, self.ramp_duration)

        self.deltas = self.distribution if len(self.distribution) <= 1 else [ self.distribution[i] - (0 if i <=0 else self.distribution[i-1]) for i in range(0,len(self.distribution)) ]

        # if self.ramp_method in ['normal']:
        #     if len(self.distribution) < (0.7 * self.ramp_duration):
        #         logging.warn(f"Parameters for normal distribution (n={self.users_count}, mu_ratio={self.ramp_mu_ratio}, sigma={self.ramp_sigma}) are too steep, and significantly reduce ramp up duration ({len(self.distribution)}s vs {self.ramp_duration}s).")
        #     if max(self.deltas[0], self.deltas[1]) > 1 and max(self.deltas[0], self.deltas[-1]) > (0.1 * self.users_count):
        #         logging.warn(f"Parameters for normal distribution (n={self.users_count}, mu_ratio={self.ramp_mu_ratio}, sigma={self.ramp_sigma}) are too loose, and significantly impact first and/or last ramp up iteration ({max(self.deltas[0], self.deltas[-1])}/{self.users_count} users on spawn).")

        return self.distribution


    def tick(self):
        if not hasattr(self, 'distribution') or self.distribution == None:
            self.ramp_method = self.runner.environment.parsed_options.ramp_method
            self.ramp_duration = self.runner.environment.parsed_options.ramp_duration
            self.ramp_mu_ratio = self.runner.environment.parsed_options.ramp_mu_ratio
            self.ramp_sigma = self.runner.environment.parsed_options.ramp_sigma
            self.selected_profile = self.runner.environment.parsed_options.load_profile

            self.users_count = mappize(profiles, "name")[self.selected_profile]["users_count"]

            self.build_distribution()

        run_time = int(self.get_run_time())

        if run_time >= len(self.distribution) or self.distribution[run_time] >= self.users_count:
            TestingConfig.spawning_complete = True
            return (self.users_count, self.users_count)
        
        if run_time == 0:
            return (self.distribution[run_time], max(1,self.distribution[run_time]))

        return (self.distribution[run_time], max(1,self.distribution[run_time]-self.distribution[run_time-1]))

    def __repr__(self):
        return '\n'.join([
            f'{self.users_count} users will ramp up {self.ramp_method} during {len(self.distribution)}s:',
            '|  Time   | Delta   | Users  |',
            '|---------+---------+--------|',
            ]+ [f'| {i:>6}s | +{self.deltas[i]:>6} | {self.distribution[i]:>6} |' for i in range(0,len(self.distribution))])

