from users.tao import TAOUser
from locust import task
import actions
from config import testTakersBank
from utils.stoppable_task_set import OnceTaskSet

class TestTaker(TAOUser):
    bank = testTakersBank
    
    @task
    class TestTakerTaskSet(OnceTaskSet):
        tasks = [
            actions.auth.login,
            actions.sessions.get_active_session,
            actions.lti.get_lti_delivery_execution,
            actions.lti.open_lti_delivery_execution,
            actions.lti.open_lti_action_delivery_execution,
            actions.lti.open_lti_action_proctoring,
            actions.lti.open_lti_action_deliver,
            actions.auth.refresh_tokens,
            actions.testrunner.init_actions,
            actions.testrunner.delivery_config,
            actions.testrunner.execute_items,
            ]

