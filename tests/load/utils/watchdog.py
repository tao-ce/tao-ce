from locust import events
from locust.runners import STATE_INIT, STATE_STOPPED, STATE_STOPPING, STATE_CLEANUP
import gevent, time, logging
from .counts import actives, started, targets
from config import TestingConfig

def watchdog(environment):
    logging.info(f'Starting test session for {targets(environment)} users')
    while environment.runner.state in [STATE_INIT]:
        time.sleep(1)

    while not TestingConfig.spawning_complete and (not environment.runner.state in [STATE_CLEANUP, STATE_STOPPING, STATE_STOPPED]):
        logging.info(f'Ramping up {started(environment)}/{targets(environment)} users ({actives(environment)} running)...')
        time.sleep(1)

    while actives(environment) > 0:
        logging.info(f'{actives(environment)}/{targets(environment)} users still active...')
        time.sleep(1)

    logging.info('No active users left, stopping test session')
    time.sleep(2)
    environment.runner.quit()

@events.test_start.add_listener
def start_watchdog_on_test_start(environment, **kw):
    gevent.spawn(watchdog, environment)

@events.test_stop.add_listener
def stop_spawning_on_test_stop(environment, **kw):
    TestingConfig.spawning_complete = True