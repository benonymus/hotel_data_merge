defmodule HotelDataMergeWeb.HotelControllerTest do
  use HotelDataMergeWeb.ConnCase, async: true

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # for a real world test I would mock the request
  # but in this case the remote server is a mock server
  test "index", %{conn: conn} do
    conn = get(conn, ~p"/api/hotels")

    assert json_response(conn, 200)["data"] == desired_result()
  end

  defp desired_result do
    [
      %{
        "amenities" => %{
          "general" => [
            "Pool",
            "Business center",
            "Wi fi",
            "Dry cleaning",
            "Breakfast",
            "Outdoor pool",
            "Indoor pool",
            "Childcare"
          ],
          "room" => ["Aircon", "Tv", "Coffee machine", "Kettle", "Hair dryer", "Iron", "Tub"]
        },
        "booking_conditions" => [
          "All children are welcome one child under 12 years stays free of charge when using existing beds one child under 2 years stays free of charge in a child's cot/crib one child under 4 years stays free of charge when using existing beds one older child or adult is charged sgd 82 39 per person per night in an extra bed the maximum number of children's cots/cribs in a room is 1 there is no capacity for extra beds in the room",
          "Pets are not allowed",
          "Wi fi is available in all areas and is free of charge",
          "Free private parking is possible on site (reservation is not needed)",
          "Guests are required to show a photo identification and credit card upon check in please note that all special requests are subject to availability and additional charges may apply payment before arrival via bank transfer is required the property will contact you after you book to provide instructions please note that the full amount of the reservation is due before arrival resorts world sentosa will send a confirmation with detailed payment information after full payment is taken, the property's details, including the address and where to collect keys, will be emailed to you bag checks will be conducted prior to entry to adventure cove waterpark === upon check in, guests will be provided with complimentary sentosa pass (monorail) to enjoy unlimited transportation between sentosa island and harbour front ( vivo city) === prepayment for non refundable bookings will be charged by rws call centre === all guests can enjoy complimentary parking during their stay, limited to one exit from the hotel per day === room reservation charges will be charged upon check in credit card provided upon reservation is for guarantee purpose === for reservations made with inclusive breakfast, please note that breakfast is applicable only for number of adults paid in the room rate any children or additional adults are charged separately for breakfast and are to paid directly to the hotel"
        ],
        "description" =>
          "Located at the western tip of Resorts World Sentosa, guests at the Beach Villas are guaranteed privacy while they enjoy spectacular views of glittering waters. Guests will find themselves in paradise with this series of exquisite tropical sanctuaries, making it the perfect setting for an idyllic retreat. Within each villa, guests will discover living areas and bedrooms that open out to mini gardens, private timber sundecks and verandahs elegantly framing either lush greenery or an expanse of sea. Guests are assured of a superior slumber with goose feather pillows and luxe mattresses paired with 400 thread count Egyptian cotton bed linen, tastefully paired with a full complement of luxurious in-room amenities and bathrooms boasting rain showers and free-standing tubs coupled with an exclusive array of ESPA amenities and toiletries. Guests also get to enjoy complimentary day access to the facilities at Asia’s flagship spa – the world-renowned ESPA.",
        "destination_id" => 5432,
        "id" => "iJhz",
        "images" => %{
          "amenities" => [
            %{
              "description" => "RWS",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/0.jpg"
            },
            %{
              "description" => "Sentosa Gateway",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/6.jpg"
            }
          ],
          "rooms" => [
            %{
              "description" => "Double room",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg"
            },
            %{
              "description" => "Bathroom",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/4.jpg"
            },
            %{
              "description" => "Double room",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg"
            }
          ],
          "site" => [
            %{
              "description" => "Front",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg"
            }
          ]
        },
        "location" => %{
          "address" => "8 Sentosa Gateway, Beach Villas, 098269",
          "city" => "Singapore",
          "country" => "Singapore",
          "lat" => "1.264751",
          "lng" => "103.824006"
        },
        "name" => "Beach Villas Singapore"
      },
      %{
        "amenities" => %{
          "general" => [
            "Pool",
            "Wi fi",
            "Business center",
            "Dry cleaning",
            "Breakfast",
            "Bar",
            "Bath tub",
            "Indoor pool"
          ],
          "room" => ["Tv", "Aircon", "Minibar", "Bathtub", "Hair dryer"]
        },
        "booking_conditions" => [
          "All children are welcome one child under 6 years stays free of charge when using existing beds there is no capacity for extra beds in the room",
          "Pets are not allowed",
          "Wired internet is available in the hotel rooms and charges are applicable wi fi is available in the hotel rooms and charges are applicable",
          "Private parking is possible on site (reservation is not needed) and costs jpy 1500 per day",
          "When booking more than 9 rooms, different policies and additional supplements may apply",
          "The hotel's free shuttle is offered from bus stop 21 in front of keio department store at shinjuku station it is available every 20 minutes from 08:20 21:40 the hotel's free shuttle is offered from the hotel to shinjuku train station it is available every 20 minutes from 08:12 21:52 for more details, please contact the hotel directly at the executive lounge a smart casual dress code is strongly recommended attires mentioned below are strongly discouraged and may not permitted: night attire (slippers, yukata robe, etc ) gym clothes/sportswear ( tank tops, shorts, etc ) beachwear (flip flops, sandals, etc ) and visible tattoos please note that due to renovation works, the executive lounge will be closed from 03 january 2019 until late april 2019 during this period, guests may experience some noise or minor disturbances smoking preference is subject to availability and cannot be guaranteed"
        ],
        "description" =>
          "This sleek high-rise property is 10 minutes' walk from Shinjuku train station, 6 minutes' walk from the Tokyo Metropolitan Government Building and 3 km from Yoyogi Park. The polished rooms offer Wi-Fi and flat-screen TVs, plus minibars, sitting areas, and tea and coffeemaking facilities. Suites add living rooms, and access to a club lounge serving breakfast and cocktails. A free shuttle to Shinjuku station is offered. There's a chic Chinese restaurant, a sushi bar, and a grill restaurant with an open kitchen, as well as an English pub and a hip cocktail lounge. Other amenities include a gym, rooftop tennis courts, and a spa with an indoor pool.",
        "destination_id" => 1122,
        "id" => "f8c9",
        "images" => %{
          "amenities" => [
            %{
              "description" => "Bar",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/YwAr/i57_m.jpg"
            }
          ],
          "rooms" => [
            %{
              "description" => "Suite",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/YwAr/i10_m.jpg"
            },
            %{
              "description" => "Suite - Living room",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/YwAr/i11_m.jpg"
            },
            %{
              "description" => "Suite",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/YwAr/i1_m.jpg"
            },
            %{
              "description" => "Double room",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/YwAr/i15_m.jpg"
            }
          ],
          "site" => [
            %{
              "description" => "Bar",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/YwAr/i55_m.jpg"
            }
          ]
        },
        "location" => %{
          "address" => "160-0023, SHINJUKU-KU, 6-6-2 NISHI-SHINJUKU, JAPAN",
          "city" => "Tokyo",
          "country" => "Japan",
          "lat" => "35.6926",
          "lng" => "139.690965"
        },
        "name" => "Hilton Shinjuku Tokyo"
      },
      %{
        "amenities" => %{
          "general" => [
            "Pool",
            "Wi fi",
            "Aircon",
            "Business center",
            "Bath tub",
            "Breakfast",
            "Dry cleaning",
            "Bar",
            "Outdoor pool",
            "Childcare",
            "Parking",
            "Concierge"
          ],
          "room" => ["Aircon", "Minibar", "Tv", "Bathtub", "Hair dryer"]
        },
        "booking_conditions" => [],
        "description" =>
          "InterContinental Singapore Robertson Quay is luxury's preferred address offering stylishly cosmopolitan riverside living for discerning travelers to Singapore. Prominently situated along the Singapore River, the 225-room inspiring luxury hotel is easily accessible to the Marina Bay Financial District, Central Business District, Orchard Road and Singapore Changi International Airport, all located a short drive away. The hotel features the latest in Club InterContinental design and service experience, and five dining options including Publico, an Italian landmark dining and entertainment destination by the waterfront.",
        "destination_id" => 5432,
        "id" => "SjyX",
        "images" => %{
          "amenities" => [],
          "rooms" => [
            %{
              "description" => "Double room",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i93_m.jpg"
            },
            %{
              "description" => "Bathroom",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i94_m.jpg"
            }
          ],
          "site" => [
            %{
              "description" => "Restaurant",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i1_m.jpg"
            },
            %{
              "description" => "Hotel Exterior",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i2_m.jpg"
            },
            %{
              "description" => "Entrance",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i5_m.jpg"
            },
            %{
              "description" => "Bar",
              "link" => "https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i24_m.jpg"
            }
          ]
        },
        "location" => %{
          "address" => "1 Nanson Rd, Singapore 238909",
          "city" => "Singapore",
          "country" => "Singapore",
          "lat" => nil,
          "lng" => nil
        },
        "name" => "InterContinental Singapore Robertson Quay"
      }
    ]
  end
end
