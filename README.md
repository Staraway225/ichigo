# Ichigo

Simple and lightweight SauceNAO API wrapper written in Crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     ichigo:
       github: Staraway225/ichigo
       version: 0.1.1
   ```

2. Run `shards install`

## Usage

```crystal
require "ichigo"
```

### Examples

1. Search by an image url:

   ```crystal
   client = Ichigo::Client.new "your_saucenao_api_key_here"
   response = client.search "https://example.com/image.png"

   pp response
   ```

2. Search by a local image:

   - by an image path as `String`:

     ```crystal
     image = "/path/to/image.png"

     client = Ichigo::Client.new "your_saucenao_api_key_here"
     response = client.search(file: image)

     pp response
     ```

   - by an image path as `Path` object:

     ```crystal
     image = Path["/path/to/image.png"]

     client = Ichigo::Client.new "your_saucenao_api_key_here"
     response = client.search(file: image)

     pp response
     ```

   - by an image as `File` object:

     ```crystal
     image = File.new("/path/to/image.png")

     client = Ichigo::Client.new "your_saucenao_api_key_here"
     response = client.search(file: image)

     pp response
     ```

   - by an image as `IO` object:

     ```crystal
     image = IO::Memory.new File.read("/path/to/image.png")

     client = Ichigo::Client.new "your_saucenao_api_key_here"
     response = client.search(file: image)

     pp response
     ```

You can also use `Ichigo::RawClient` to perform a request with raw values:

```crystal
raw_client = Ichigo::RawClient.new "your_saucenao_api_key_here"
response = raw_client.search(
  url: "https://example.com/image.png",
  mask: 8191_i64,
  site: 5,
  result_count: 8
)

pp response
```

## Contributing

1. Make your changes.
2. Add additional specs if you introduced new logic, make sure they pass (`crystal spec`).
3. Run the code formatter (`crystal tool format`).
4. Check for code issues by using linter (`bin/ameba`).
5. Create a new pull request.
