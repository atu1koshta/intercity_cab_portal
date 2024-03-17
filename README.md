# City Registration API

This API allows users to register a city with optional parameters.

## Register a City

### Endpoint

`POST /cities`

### Request Parameters

- `city`: (optional) An object containing the city details.
  - `id`: (optional) The ID of the city.
  - `name`: (optional) The name of the city.

### Request Body

The request body can be empty for creating a city with a random ID or can contain the city object with ID and name.

```json
{
  "city": {
    "id": 23340,
    "name": "City Name"
  }
}
```


# Cab Registration API

This API allows users to register a cab in a city with optional parameters.

## Register a Cab

### Endpoint

`POST /cabs`

### Request Parameters

- `cab`: An object containing the cab details.
  - `city_id`: The ID of the city where the cab is being registered.
  - `state`: The state of the cab. Default is "IDLE".

### Request Body

To register a cab in a city (must be registered) with default state as "IDLE":

```json
{
  "cab": {
    "city_id": 23340
  }
}
```

To register a cab with default state as "ON_TRIP":

```json
{
  "cab": {
    "state": "ON_TRIP"
  }
}
```

# Cab Management API

This API facilitates managing the state of cabs.

## Update Cab State

### Endpoint

`PUT /cabs/:id`

### Path Parameters

- `id`: The ID of the cab to be updated.

### Request Body

To change the cab's state from 'ON_TRIP' to 'IDLE', a valid `city_id` must be provided:

```json
{
  "cab": {
    "state": "IDLE",
    "city_id": 23339
  }
}
```

To change the cab's state from 'IDLE' to 'ON_TRIP', only state param is required:

```json
{
  "cab": {
    "state": "ON_TRIP"
  }
}
```

# Cab Booking API

This API enables users to book a cab in a specified city.

## Book a Cab

### Endpoint

`POST /cabs/book`

### Request Body

To book a cab, provide the `city_id` where the cab should be booked. Ensure that the `city_id` is valid.

```json
{
  "city_id": 23340
}
```

# Cab Insight API

This API provides insights into the total idle time of a cab within a given date-time range.

## Get Cab Insights

### Endpoint

`GET /cabs/:id/insights`

### Path Parameters

- `id`: The ID of the cab.

### Query Parameters

- `state_datetime`: Datetime in YYYY-MM-DD hh:mm:ss format (IST), indicating the start of the date-time range.
- `end_datetime`: Datetime in YYYY-MM-DD hh:mm:ss format (IST), indicating the end of the date-time range.
