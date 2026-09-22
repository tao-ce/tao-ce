import utils.exception

def list_sessions(task):
    with task.user.client.get(
        f"{task.user.config.endpoints.portalBackend}/api/v1/sessions/user?status=active",
        name=task.name(f'{__name__}.list_sessions'),
        headers={}
            | task.user.headers.authorization()
            | task.user.headers.json()
        ,
        catch_response=True,
    ) as response:
        response.success()
        return response.json().get('data',[])

def get_active_session(task):
    sessions = list_sessions(task)
    if len(sessions) <= 0:
        raise exception.EmptyList('no active sessions found')

    session = sessions[0]
    task.user.push('session_id', session['sessionId'])
    task.user.push('delivery_id', session['deliveryId'])
