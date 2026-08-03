actives = lambda environment : sum([ 
    (( len(x.args) > 0 ) and x.args[0].active )
    for x in environment.runner.user_greenlets
    ])

started = lambda environment : environment.runner.user_count
targets = lambda environment : environment.runner.target_user_count
