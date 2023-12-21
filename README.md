# Keptn Examples

## Keptn V1 has reached end of life on December 22nd, 2023 and has been [replaced](https://github.com/keptn/lifecycle-toolkit).

This directory contains and refers to examples in order to explore the functionality of Keptn. Please visit [keptn.sh](https://keptn.sh) for more information about Keptn.

## Maintained Examples

Maintained examples are updated with every [Keptn release](https://github.com/keptn/examples/releases) to use the latest features, current guidelines and best practices, as well as to update command syntax, output, or changed prerequisites.

<!-- See [Example Guidelines](guidelines.md) for a description of what goes in this directory, and what examples should contain. -->

### Carts

This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh).

You can find the source code of the carts microservice at https://github.com/keptn-sockshop/carts

#### Load Generator for Carts

The following commands will set up a basic load generator for the carts microservice that generates traffic in **all three stages**:

* Basic (Background traffic)
  ```console
  kubectl apply -f https://raw.githubusercontent.com/keptn/examples/master/load-generation/cartsloadgen/deploy/cartsloadgen-base.yaml
  ```
* More traffic
  ```console
  kubectl apply -f https://raw.githubusercontent.com/keptn/examples/master/load-generation/cartsloadgen/deploy/cartsloadgen-fast.yaml
  ```
* Faulty item in cart (generates cpu usage)
  ```console
  kubectl apply -f https://raw.githubusercontent.com/keptn/examples/master/load-generation/cartsloadgen/deploy/cartsloadgen-faulty.yaml
  ```

### Unleash

This example allows to demonstrate the [Self-healing with Feature Flags tutorials](https://tutorials.keptn.sh).

You can find the source of the unleash service at https://github.com/keptn-sockshop/unleash-server

### Simplenodeservice

This example is used for some of the [Keptn tutorials](https://tutorials.keptn.sh).

More information about this simple node.js based example application can be found here: [Simplenodeservice README](./simplenodeservice/README.md)

## License

See [LICENSE](LICENSE).

## Contributing

If you want to contribute, just create a PR on the master branch.

Please also see [CONTRIBUTING.md](CONTRIBUTING.md) instructions on how to contribute.
