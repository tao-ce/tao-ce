#!/bin/sh
#

sub=$1
action=$2
shift 2

case $sub in
    topic)
        case $action in
            create)
                topic_name=$1
                /bin/grpcurl-wrapper google.pubsub.v1.Publisher.CreateTopic -d '{"name":"projects/'${PUBSUB_PROJECT_ID}'/topics/'${topic_name}'"}'
                ;;
        esac    
        ;;
    subscription)
        case $action in
            create)
                topic_name=$1
                sub_name=$2
                /bin/grpcurl-wrapper google.pubsub.v1.Subscriber.CreateSubscription -d '{"name":"projects/'${PUBSUB_PROJECT_ID}'/subscriptions/'${sub_name}'","topic":"projects/'${PUBSUB_PROJECT_ID}'/topics/'${topic_name}'"}'
                ;;
        esac
        ;;
esac