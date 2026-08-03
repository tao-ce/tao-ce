from locust import  events
from config import TestingConfig, profiles, wait_times
import logging
from utils.test_shape import CustomLoadTestShape

mappize = lambda m, n : {k: v for k, v in [(x[n], x) for x in m]}

@events.init_command_line_parser.add_listener
def on_parse(parser):
    parser.add_argument("--load_profile", choices=[x["name"] for x in profiles], default=profiles[0]["name"])
    parser.add_argument("--wait_time", choices=[x["name"] for x in wait_times], default=wait_times[0]["name"])
    parser.add_argument("--ramp_method", choices=['linear', 'normal', 'instant', 'exponential'], default='linear')
    parser.add_argument("--ramp_duration", type=int, default=120)
    parser.add_argument("--ramp_mu_ratio", type=float, default=0.5)
    parser.add_argument("--ramp_sigma", type=float, default=0.1)


@events.test_start.add_listener
def change_wait_time(environment, **kwargs):
    TestingConfig.wait_time = mappize(wait_times,"name")[environment.parsed_options.wait_time]["wait"]
    logging.info(environment.shape_class)


@events.test_stop.add_listener
def on_stop_clean_parameters(environment, **kwargs):
    environment.shape_class.distribution = None
