# Keptn Examples

This directory contains and refers to examples in order to explore the functionality of Keptn. Please visit [keptn.sh](https://keptn.sh) for more information about Keptn.

## Maintained Examples

Maintained examples are updated with every [Keptn release](https://github.com/keptn/examples/releases) to use the latest features, current guidelines and best practices, as well as to update command syntax, output, or changed prerequisites.

<!-- See [Example Guidelines](guidelines.md) for a description of what goes in this directory, and what examples should contain. -->

### Carts

|Name | Version | Description | 
------------- | ------------- | ------------ |
| **onboard-carts** | [0.8.4](https://github.com/keptn/examples/tree/release-0.8.4) | This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh). |
| **onboard-carts** | [0.8.3](https://github.com/keptn/examples/tree/release-0.8.3) | This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh). |
| **onboard-carts** | [0.8.2](https://github.com/keptn/examples/tree/release-0.8.2) | This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh). |
| **onboard-carts** | [0.8.1](https://github.com/keptn/examples/tree/release-0.8.1) | This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh). |
| **onboard-carts** | [0.8.0](https://github.com/keptn/examples/tree/release-0.8.0) | This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh). |
| **onboard-carts** | [0.8.0-alpha](https://github.com/keptn/examples/tree/release-0.8.0-alpha) | Examples for Keptn 0.8.0-alpha, no tutorial available yet. |
| **onboard-carts** | [0.7.3](https://github.com/keptn/examples/tree/release-0.7.3) | This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh). |
| **onboard-carts** | [0.7.2](https://github.com/keptn/examples/tree/release-0.7.2) | This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh). |
| **onboard-carts** | [0.7.1](https://github.com/keptn/examples/tree/release-0.7.1) | This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh). |
| **onboard-carts** | [0.7.0](https://github.com/keptn/examples/tree/release-0.7.0) | This example allows to demonstrate the [Keptn tutorials](https://tutorials.keptn.sh). |
| **onboard-carts** | [0.6.2](https://github.com/keptn/examples/tree/release-0.6.2) | This example allows to demonstrate the [Keptn use cases](https://keptn.sh/docs/0.6.0/usecases/). |
| **onboard-carts** | [0.6.1](https://github.com/keptn/examples/tree/release-0.6.1) | This example allows to demonstrate the [Keptn use cases](https://keptn.sh/docs/0.6.0/usecases/). |
| **onboard-carts** | [0.6.0](https://github.com/keptn/examples/tree/release-0.6.0) | This example allows to demonstrate the [Keptn use cases](https://keptn.sh/docs/0.6.0/usecases/). |
| **onboard-carts** | [0.5.0](https://github.com/keptn/examples/tree/release-0.5.0) | This example allows to demonstrate the [Keptn use cases](https://keptn.sh/docs/0.5.0/usecases/). |

You can find the source code of the carts microservice at https://github.com/keptn-sockshop/carts

#### Load Generator for Carts

The following commands will set up a basic load generator for the carts microservice that generates traffic in **all three stages**:

* Keptn 0.7.x and 0.8.x:
  * Basic (Background traffic)
    ```console
    kubectl apply -f https://raw.githubusercontent.com/keptn/examples/release-0.8.2/load-generation/cartsloadgen/deploy/cartsloadgen-base.yaml
    ```
  * More traffic
    ```console
    kubectl apply -f https://raw.githubusercontent.com/keptn/examples/release-0.8.2/load-generation/cartsloadgen/deploy/cartsloadgen-fast.yaml
    ```
  * Faulty item in cart (generates cpu usage)
    ```console
    kubectl apply -f https://raw.githubusercontent.com/keptn/examples/release-0.8.2/load-generation/cartsloadgen/deploy/cartsloadgen-faulty.yaml
    ```

### Unleash

|Name | Version | Description | 
------------- | ------------- | ------------ |
| **unleash-server** | [0.8.x](https://github.com/keptn/examples/tree/release-0.8.2) | This example allows to demonstrate the [Self-healing with Feature Flags tutorials](https://tutorials.keptn.sh). |
| **unleash-server** | [0.7.x](https://github.com/keptn/examples/tree/release-0.7.3) | This example allows to demonstrate the [Self-healing with Feature Flags tutorials](https://tutorials.keptn.sh). |
| **unleash-server** | [0.6.x](https://github.com/keptn/examples/tree/release-0.6.2) | This example allows to demonstrate the [Self-healing with Feature Flags usecase](https://keptn.sh/docs/0.6.0/usecases/self-healing-with-keptn/dynatrace-unleash/). |

You can find the source of the unleash service at https://github.com/keptn-sockshop/unleash-server

### Simplenodeservice

|Name | Version | Description | 
------------- | ------------- | ------------ |
| **simplenode** |  [0.7.x](https://github.com/keptn/examples/tree/release-0.7.3) | This example is used for some of the [Keptn tutorials](https://tutorials.keptn.sh) |
| **simplenode** |  [0.6.x](https://github.com/keptn/examples/tree/release-0.6.2) | This example is used for some of the [Keptn tutorials](https://tutorials.keptn.sh) |

More information about this simple node.js based example application can be found here: [Simplenodeservice README](./simplenodeservice/README.md)

## License

See [LICENSE](LICENSE).

## Contributing

If you want to contribute, just create a PR on the master branch.

Please also see [CONTRIBUTING.md](CONTRIBUTING.md) instructions on how to contribute.
