from locust.contrib.fasthttp import FastHttpUser
from locust.exception import InterruptTaskSet
from config import TestingConfig
import time
import utils.exception
import logging

class TAOUser(FastHttpUser):
    abstract: bool = True
    bank = None

    class Context(dict):
        def ensure(self, key):
            value = self.get(key)
            if not value:
                raise exception.MissingContext(f'missing {key}')
            return value

    class Headers:
        def __init__(self, user):
            self.user = user

        def authorization(self):
            return {
                'Authorization': f"Bearer {self.user.ctx.ensure('access_token')}",
            }

        def json(self):
            return {
                'Content-Type': 'application/json',
            }

        def origin(self):
            return {
                'Origin': self.user.host,
            }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        bank_user = next(self.bank)
        self.username = bank_user.username
        self.password = bank_user.password
        self.config = TestingConfig(self)
        self.wait_time = self.config.wait_time
        self.active = True
        self.dying = False
        self.ctx = self.Context()
        self.headers = self.Headers(self)

    def __repr__(self):
        return f'{self.__class__.__name__}/{self.username}'

    def context(self):
        return self.ctx


    def get(self, k):
        return self.ctx.get(k,None)

    def push(self, k, v):
        self.ctx[k] = v

    def on_start(self):
        super().on_start()
        logging.debug(f'starting {self}')

    def on_sleep(self):
        logging.debug(f'sleeping {self}')
        while not self.config.spawning_complete:
            time.sleep(0.1)

    def on_stop(self):
        self.active = False
        self.on_sleep()
        logging.debug(f'stopping {self}')

    def handle_exception(self, e):
        match e.__class__:
            case _:
                logging.error(f'{e.__class__.__name__}: {e} ({self})')
        raise InterruptTaskSet(reschedule=False)
