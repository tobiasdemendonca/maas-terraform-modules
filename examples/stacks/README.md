# Example stacks 

This directory contains example stacks that can be used as a reference when creating a stack file specific to a particular deployment. Each stack is a a complete configuration file that describes how to spin up an entire deployment of all modules included in the stack. 

To test out one of the example stacks, simple cd into a particular directory, generate and apply the stack:

```bash
cd examples/stacks/single-node
terragrunt stack generate       #  Creates a collection of units in `./.terragrunt-stack` directory
terragrunt stack run apply      #  Applies the generated stack
```
