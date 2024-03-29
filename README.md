# HotelDataMerge

To start the application locally:

  * Run `mix deps.get` to install and setup dependencies
  * Start the Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The deployed version can be found at (the first load might take a few seconds, it is a cold start): https://hotel-data-merge.fly.dev/api/hotels

The following filters are available (with any desired value):

- `?destination=1122`
- `?hotels[]=f8c9&hotels[]=SjyX`

## Thoughts on performance and other aspects

For data gathering I run the requests and processing concurrently.
I used `Stream` for the heavy lifting to save us from extra looping.
The merging of the clean data is done recursively and with async_stream (this would offer more benefit as the number of hotels and providers grow).

I tried to make the setup easy to extend. It is simple to add a new provider for example.
You only need to create the new params for the initial mapping of the new external data and add the new provider attrs to the async_stream in the `data.ex` file.

The setup with the params and with the embedded schema allows us to validate the external data easily.

I added caching for the unified entries per provider.
This sidesteps the request and subsequent processing of external data for 30 seconds (short limit in case remote data changes) and then applies the filters on this data set.
I considered caching the entire set of the grouped data at a level higher.
I decided against this because it would make the setup less flexible.
The current setup allows matching and mixing providers as we see fit while caching on the top level would lock us in more.

I decided against adding a database as the important functionality is the data procurement and merging. Storing it does not seem neccessary.
