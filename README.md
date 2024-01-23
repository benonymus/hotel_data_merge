# HotelDataMerge

To start the application locally:

  * Run `mix deps.get` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The deployed version can be found at (the first load might take a few seconds, it is a cold start): https://hotel-data-merge.fly.dev/api/hotels

The following filters are available (with any desired value):

- `?destination_id=1122`
- `?hotel_ids[]=f8c9&hotel_ids[]=SjyX`

## Thoughts on performance and other aspects

For data gathering I run the requests and processing concurrently.
I used `Stream` for the heavy lifting to save us from extra looping.
The merging of the clean data is done recursively and with async_stream (this would offer more benefit as the number of hotels grow).

I tried to make the setup easy to extend. It is simple to add a new provider for example.
You only need to create the new params for the initial mapping and add the new provider and Task to the `data.ex` file.

The setup with the params and with the embedded schema allows us to validate the external data easily.

In the real world I would consider adding caching depending on the use case of the service.
It would probably be the best to cache the responses or the cleaned data set before merging.
Alternatively with caching in place a different way of applying the filters could be considered.
We could cache the fully processed data set and run the filters against that.
If there are many consecutive requests for the same data then I think it is worth to add, but with a short retention period to not serve out of date data.
