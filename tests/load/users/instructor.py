from users.tao import TAOUser
from locust import task
import actions
from config import instructorsBank
from utils.stoppable_task_set import OnceTaskSet

class Instructor(TAOUser):
    bank = instructorsBank 
    
    @task
    class InstructorTaskSet(OnceTaskSet):
        tasks = [
            actions.auth.login,
            ]

