#! /bin/bash
set -e

DIR=$(dirname $0)

if [ -z "$REGISTRY" ]; then
  REGISTRY=azure-functions/
fi

if [ -z "$HOST_VERSION" ]; then
  HOST_VERSION=2.0
fi

function test_image {
  npm run test $1 --prefix $DIR/../test
}

function build {
  # build base image
  docker build -t "${REGISTRY}base:${HOST_VERSION}" -f $DIR/../host/2.0/stretch/amd64/base.Dockerfile $DIR/../host/2.0/stretch/amd64/

  # build node:$HOST_VERSION.x-node8 and node:$HOST_VERSION.x-node8-appservice
  docker build -t "${REGISTRY}node:${HOST_VERSION}-node8"            -f $DIR/../host/2.0/stretch/amd64/node8.Dockerfile            --build-arg BASE_IMAGE="${REGISTRY}base:${HOST_VERSION}"       $DIR/../host/2.0/stretch/amd64/
  docker build -t "${REGISTRY}node:${HOST_VERSION}-node8-appservice" -f $DIR/../host/2.0/stretch/amd64/appservice/node8.Dockerfile --build-arg BASE_IMAGE="${REGISTRY}node:${HOST_VERSION}-node8" $DIR/../host/2.0/stretch/amd64/appservice
  test_image "${REGISTRY}node:${HOST_VERSION}-node8"
  test_image "${REGISTRY}node:${HOST_VERSION}-node8-appservice"

  # build node:$HOST_VERSION.x-node10 and node:$HOST_VERSION.x-node10-appservice
  docker build -t "${REGISTRY}node:${HOST_VERSION}-node10"            -f $DIR/../host/2.0/stretch/amd64/node10.Dockerfile            --build-arg BASE_IMAGE="${REGISTRY}base:${HOST_VERSION}"        $DIR/../host/2.0/stretch/amd64/
  docker build -t "${REGISTRY}node:${HOST_VERSION}-node10-appservice" -f $DIR/../host/2.0/stretch/amd64/appservice/node10.Dockerfile --build-arg BASE_IMAGE="${REGISTRY}node:${HOST_VERSION}-node10" $DIR/../host/2.0/stretch/amd64/appservice
  test_image "${REGISTRY}node:${HOST_VERSION}-node10"
  test_image "${REGISTRY}node:${HOST_VERSION}-node10-appservice"

  # build node:$HOST_VERSION.x-node12 and node:$HOST_VERSION.x-node12-appservice
  docker build -t "${REGISTRY}node:${HOST_VERSION}-node12"            -f $DIR/../host/2.0/stretch/amd64/node8.Dockerfile            --build-arg BASE_IMAGE="${REGISTRY}base:${HOST_VERSION}"        $DIR/../host/2.0/stretch/amd64/
  docker build -t "${REGISTRY}node:${HOST_VERSION}-node12-appservice" -f $DIR/../host/2.0/stretch/amd64/appservice/node8.Dockerfile --build-arg BASE_IMAGE="${REGISTRY}node:${HOST_VERSION}-node12" $DIR/../host/2.0/stretch/amd64/appservice
  test_image "${REGISTRY}node:${HOST_VERSION}-node12"
  test_image "${REGISTRY}node:${HOST_VERSION}-node12-appservice"

  # tag default node:$HOST_VERSION.x and node:$HOST_VERSION.x-appservice
  docker tag "${REGISTRY}node:${HOST_VERSION}-node8"            "${REGISTRY}node:${HOST_VERSION}"
  docker tag "${REGISTRY}node:${HOST_VERSION}-node8-appservice" "${REGISTRY}node:${HOST_VERSION}-appservice"

  # tag quickstart image
  docker tag "${REGISTRY}node:${HOST_VERSION}-appservice" "${REGISTRY}node:${HOST_VERSION}-appservice-quickstart"
}

function push {
  # push default node:$HOST_VERSION.x and node:$HOST_VERSION.x-appservice images
  docker push "${REGISTRY}node:${HOST_VERSION}"
  docker push "${REGISTRY}node:${HOST_VERSION}-appservice"
  docker push "${REGISTRY}node:${HOST_VERSION}-appservice-quickstart"

  # push default node:$HOST_VERSION.x-node8 and node:$HOST_VERSION.x-node8-appservice images
  docker push "${REGISTRY}node:${HOST_VERSION}-node8"
  docker push "${REGISTRY}node:${HOST_VERSION}-node8-appservice"

  # push default node:$HOST_VERSION.x-node10 and node:$HOST_VERSION.x-node10-appservice images
  docker push "${REGISTRY}node:${HOST_VERSION}-node10"
  docker push "${REGISTRY}node:${HOST_VERSION}-node10-appservice"

  # push default node:$HOST_VERSION.x-node12 and node:$HOST_VERSION.x-node12-appservice images
  docker push "${REGISTRY}node:${HOST_VERSION}-node12"
  docker push "${REGISTRY}node:${HOST_VERSION}-node12-appservice"
}

function purge {
  # purge default node:$HOST_VERSION.x and node:$HOST_VERSION.x-appservice images
  docker rmi "${REGISTRY}node:${HOST_VERSION}"
  docker rmi "${REGISTRY}node:${HOST_VERSION}-appservice"
  docker rmi "${REGISTRY}node:${HOST_VERSION}-appservice-quickstart"

  # purge default node:$HOST_VERSION.x-node8 and node:$HOST_VERSION.x-node8-appservice images
  docker rmi "${REGISTRY}node:${HOST_VERSION}-node8"
  docker rmi "${REGISTRY}node:${HOST_VERSION}-node8-appservice"

  # purge default node:$HOST_VERSION.x-node10 and node:$HOST_VERSION.x-node10-appservice images
  docker rmi "${REGISTRY}node:${HOST_VERSION}-node10"
  docker rmi "${REGISTRY}node:${HOST_VERSION}-node10-appservice"

  # purge default node:$HOST_VERSION.x-node12 and node:$HOST_VERSION.x-node12-appservice images
  docker rmi "${REGISTRY}node:${HOST_VERSION}-node12"
  docker rmi "${REGISTRY}node:${HOST_VERSION}-node12-appservice"
}

function tag_push {
  # tag & push default node:2.0, node:2.0-appservice, and node:2.0-appservice-quickstart images
  docker pull "${REGISTRY}node:${RELEASE_VERSION}"
  docker pull "${REGISTRY}node:${RELEASE_VERSION}-appservice"
  docker pull "${REGISTRY}node:${RELEASE_VERSION}-appservice-quickstart"
  docker tag  "${REGISTRY}node:${RELEASE_VERSION}"                       "${REGISTRY}node:2.0"
  docker tag  "${REGISTRY}node:${RELEASE_VERSION}-appservice"            "${REGISTRY}node:2.0-appservice"
  docker tag  "${REGISTRY}node:${RELEASE_VERSION}-appservice-quickstart" "${REGISTRY}node:2.0-appservice-quickstart"
  docker push "${REGISTRY}node:2.0"
  docker push "${REGISTRY}node:2.0-appservice"
  docker push "${REGISTRY}node:2.0-appservice-quickstart"

  # tag & push default node:2.0-node8 and node:2.0-node8-appservice images
  docker pull "${REGISTRY}node:${RELEASE_VERSION}-node8"
  docker pull "${REGISTRY}node:${RELEASE_VERSION}-node8-appservice"
  docker tag  "${REGISTRY}node:${RELEASE_VERSION}-node8"            "${REGISTRY}node:2.0-node8"
  docker tag  "${REGISTRY}node:${RELEASE_VERSION}-node8-appservice" "${REGISTRY}node:2.0-node8-appservice"
  docker push "${REGISTRY}node:2.0-node8"
  docker push "${REGISTRY}node:2.0-node8-appservice"

  # tag & push default node:2.0-node10 and node:2.0-node10-appservice images
  docker pull "${REGISTRY}node:${RELEASE_VERSION}-node10"
  docker pull "${REGISTRY}node:${RELEASE_VERSION}-node10-appservice"
  docker tag  "${REGISTRY}node:${RELEASE_VERSION}-node10"            "${REGISTRY}node:2.0-node10"
  docker tag  "${REGISTRY}node:${RELEASE_VERSION}-node10-appservice" "${REGISTRY}node:2.0-node10-appservice"
  docker push "${REGISTRY}node:2.0-node10"
  docker push "${REGISTRY}node:2.0-node10-appservice"

  # tag & push default node:2.0-node12 and node:2.0-node12-appservice images
  docker pull "${REGISTRY}node:${RELEASE_VERSION}-node12"
  docker pull "${REGISTRY}node:${RELEASE_VERSION}-node12-appservice"
  docker tag  "${REGISTRY}node:${RELEASE_VERSION}-node12"            "${REGISTRY}node:2.0-node12"
  docker tag  "${REGISTRY}node:${RELEASE_VERSION}-node12-appservice" "${REGISTRY}node:2.0-node12-appservice"
  docker push "${REGISTRY}node:2.0-node12"
  docker push "${REGISTRY}node:2.0-node12-appservice"
}

if [ "$1" == "build" ]; then
  build
elif [ "$1" == "push" ]; then
  push
elif [ "$1" == "purge" ]; then
  purge
elif [ "$1" == "all" ]; then
  build
  push
  purge
elif [ "$1" == "tag_push" ]; then
  if [ -z "$RELEASE_VERSION" ]; then
    echo "ERROR: RELEASE_VERSION is required when running tag_push"
    exit 1
  fi
  tag_push
else
  echo "Unknown option $1"
  echo "Examples:"
  echo -e "\t$0 build"
  echo -e "\tBuilds all images tagged with HOST_VERSION and REGISTRY"
  echo ""
  echo -e "\t$0 push"
  echo -e "\tPushes all images tagged with HOST_VERSION and REGISTRY to REGISTRY"
  echo ""
  echo -e "\t$0 purge"
  echo -e "\tPurges images from local docker storage"
  echo ""
  echo -e "\t$0 all"
  echo -e "\tBuild, push and purge"
  echo ""
  echo -e "\t$0 tag_push"
  echo -e "\tTags \$RELEASE_VERSION images with 2.0 and pushes them"
  echo ""
  echo -e "\t$0 tag_push"
  echo -e "\tTags \$RELEASE_VERSION images with 2.0 and pushes them"
  echo ""
fi