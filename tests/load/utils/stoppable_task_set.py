from locust import SequentialTaskSet, task

class StoppableTaskSet(SequentialTaskSet):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._task_iter = iter(self.tasks)
        self._task_index = -1

    def name(self, name):
        return f"{self.user.__class__.__name__}#{self.current_task():03d}/{name}"

    def execute_task(self, task):
        try:
            super().execute_task(task)
        except Exception as e:
            self.user.handle_exception(e)

    def handle_exception(self, exception):
        raise exception

    def current_task(self):
        return self._task_index

    def get_next_task(self):
        try:
            self._task_index += 1
            return next(self._task_iter)
        except StopIteration:
            self.interrupt(reschedule=False)


class OnceTaskSet(StoppableTaskSet):
    def on_stop(self):
        super().on_stop()
        self.user.stop()
