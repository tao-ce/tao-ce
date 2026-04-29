import time

def init_actions(task):
    timestamp = str(int(time.time()))
    with task.user.client.post(
        f'{task.user.config.endpoints.deliver}/api/v1/delivery-executions/{task.user.get("execution_id")}/actions',
        json=[{'channel': 'actions', 'message': {'actions': [
            {'name': 'init', 'id': f'init_{timestamp}', 'timestamp': timestamp, 'parameters': {}},
        ]}}],
        name=task.name(f'{__name__}.init_actions'),
        headers={}
            | task.user.headers.authorization()
            | task.user.headers.json()
            ,

    ) as response:
        task.user.push('current_items', [
            k
            for rs in response.json()['responses']
            for r in rs
            for part in r.get("values", {}).get("testMap", {}).get("parts", {}).values()
            for section in part.get("sections", {}).values()
            for k in section.get('items',{}).keys()
            ])

def delivery_config(task):
    with task.user.client.get(
        f'{task.user.config.endpoints.deliver}/api/v1/delivery-executions/{task.user.get("execution_id")}/configuration',
        name=task.name(f'{__name__}.delivery_config'),
        headers={}
            | task.user.headers.authorization()
            | task.user.headers.json()
        ,
    ) as response:
        pass

def execute_item(task, item_idx):
    timestamp = str(int(time.time()))
    return task.user.client.post(
        f'{task.user.config.endpoints.deliver}/api/v1/delivery-executions/{task.user.get("execution_id")}/actions',
        headers={}
            | task.user.headers.authorization()
            | task.user.headers.json()
        ,
        name=task.name(f'{__name__}.execute_item#{item_idx:03d}'),
        json=[{'channel': 'actions', 'message': {'actions': [
            {'name': 'getItem', 'id': f'getItem_{timestamp}', 'timestamp': timestamp, 'parameters': { 'itemIdentifier': task.user.get('current_items')[item_idx] }},
        ]}}],
        catch_response=True,
    )

def execute_items(task):
    for item_idx in range(0, len(task.user.get('current_items'))):
        with execute_item(task, item_idx) as response:
            if response.json().get('success', False):
                response.success()
            else:
                 response.failure()



