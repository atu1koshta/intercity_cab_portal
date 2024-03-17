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

To register a cab with default state as "ON_TRIP":

```json
{
  "cab": {
    "state": "ON_TRIP"
  }
}