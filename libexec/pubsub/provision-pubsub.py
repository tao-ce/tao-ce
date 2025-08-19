from google.cloud import pubsub_v1
from google.cloud.pubsub_v1.types import DeadLetterPolicy
from google.api_core.exceptions import AlreadyExists, GoogleAPICallError
import os, sys, json

PROJECT_ID = os.getenv("PUBSUB_PROJECT_ID")

# Dead letter topic (constant)
DEAD_LETTER_TOPIC = "dead-letter"

# List of topic/subscription pairs
PAIRS = [

]

# Pub/Sub clients
publisher_client = pubsub_v1.PublisherClient()
subscriber_client = pubsub_v1.SubscriberClient()


def create_topic_if_not_exists(topic_name):
    """Create a Pub/Sub topic if it doesn't exist."""
    topic_path = publisher_client.topic_path(PROJECT_ID, topic_name)
    try:
        publisher_client.create_topic(name=topic_path)
        print(f"Created topic: {topic_name}")
    except AlreadyExists:
        print(f"Topic already exists: {topic_name}")
    except GoogleAPICallError as e:
        print(f"Failed to create topic {topic_name}: {e}")
        raise


def create_subscription_if_not_exists(topic_name, subscription_name):
    """Create a Pub/Sub subscription with a dead letter policy if it doesn't exist."""
    topic_path = publisher_client.topic_path(PROJECT_ID, topic_name)
    subscription_path = subscriber_client.subscription_path(PROJECT_ID, subscription_name)
    dead_letter_topic_path = publisher_client.topic_path(PROJECT_ID, DEAD_LETTER_TOPIC)
    max_delivery_attempts = 5

    dead_letter_policy = DeadLetterPolicy(
        dead_letter_topic=dead_letter_topic_path,
        max_delivery_attempts=max_delivery_attempts,
    )

    try:
        request = {
            "name": subscription_path,
            "topic": topic_path,
            "dead_letter_policy": dead_letter_policy,
        }
        subscription = subscriber_client.create_subscription(request)

        print(f"Created subscription: {subscription_name} (DLQ: {DEAD_LETTER_TOPIC})")
    except AlreadyExists:
        print(f"Subscription already exists: {subscription_name}")
    except GoogleAPICallError as e:
        print(f"Failed to create subscription {subscription_name}: {e}")
        raise


def main():
    """Main function to create all topics and subscriptions."""
    try:
        # Ensure the dead-letter topic exists
        create_topic_if_not_exists(DEAD_LETTER_TOPIC)

        for pair_file in sys.argv[1:]:
            print(f"\n==  Reading file {pair_file} ==")
            with open(pair_file, 'r') as file:
                pairs = json.load(file)
                for pair in pairs:
                    topic = pair["topic"]
                    subscription = pair["subscription"]

                    print(f"\n=== Handling: topic={topic}, subscription={subscription} ===")
                    create_topic_if_not_exists(topic)
                    create_subscription_if_not_exists(topic, subscription)

        print("\nAll topics and subscriptions processed successfully!")

    except Exception as e:
        print(f"Error during execution: {e}")


if __name__ == "__main__":
    main()