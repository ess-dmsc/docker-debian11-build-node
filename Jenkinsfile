@Library('ecdc-pipeline')
import ecdcpipeline.ImageBuilder

// Disable concurrent builds to avoid overwritting images in the registry.
properties([
  [$class: 'JiraProjectProperty'],
  disableConcurrentBuilds(abortPrevious: true)
])

imageVersion = '2.3.0'

imageName = "dockerregistry.esss.dk/ecdc_group/build-node-images/debian11-build-node:${imageVersion}"

imageBuilder = new ImageBuilder(this, imageName)
imageBuilder.buildAndPush()
