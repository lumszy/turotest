# pip3.7 install docker
import docker

def buildImage():
    # Replace these values with your Docker Hub credentials
    # docker_hub_username = "your-docker-hub-username"
    docker_hub_username = "lumszy"
    
    #docker_hub_repository = "your-repository-name"
    docker_hub_repository = "turotest"

    #docker_image_tag = "latest"  # You can use a specific tag for versioning
    docker_image_tag = input("Please enter release image tag|version: ")

    # Create a Docker client
    client = docker.from_env()

    # Build the Docker image
    print(f"Building Docker image: {docker_hub_username}/{docker_hub_repository}:{docker_image_tag}")
    image, build_logs = client.images.build(
        path=".",  # Path to your Dockerfile and application code
        tag=f"{docker_hub_username}/{docker_hub_repository}:{docker_image_tag}",
        rm=True  # Remove intermediate containers after a successful build
    )

    # Print build logs to screen
    for log in build_logs:
        print(log)

    # Push the Docker image to Docker Hub
    print(f"Pushing Docker image: {docker_hub_username}/{docker_hub_repository}:{docker_image_tag}")
    client.images.push(
        repository=f"{docker_hub_username}/{docker_hub_repository}",
        tag=docker_image_tag
    )

    print("Image build and push to repository is completed successfully.")

if __name__ == "__main__":

    buildImage()
