# HotelDataMerge

To start the application locally:

  * Run `mix deps.get` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The deployed version can be found at (the first load might take a few seconds, it is a cold start): https://hotel-data-merge.fly.dev/api/hotels

The following filters are available (with any desired value):

- `?destination=1122`
- `?hotels[]=f8c9&hotels[]=SjyX`

## Thoughts on performance and other aspects

For data gathering I run the requests and processing concurrently.
I used `Stream` for the heavy lifting to save us from extra looping.
The merging of the clean data is done recursively and with async_stream (this would offer more benefit as the number of hotels grow).

I tried to make the setup easy to extend. It is simple to add a new provider for example.
You only need to create the new params for the initial mapping and add the new provider and Task to the `data.ex` file.

The setup with the params and with the embedded schema allows us to validate the external data easily.

On this branch I added caching for the unified entries per provider.
This sidesteps the request and subsequent processing of external data for 30 seconds (short limit in case remote data changes) and then applies the fresh filters on this data set.
The version without caching can be seen on the main branch.

I decided against adding a database as the important functionality is the data procurement and merging. Storing it does not seem neccessary.
