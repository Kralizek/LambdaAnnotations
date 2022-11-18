using Amazon.Lambda.Core;
using Amazon.Lambda.Annotations;
using System.Text.Json.Serialization;
using System.Net.Http.Json;
using Microsoft.Extensions.DependencyInjection;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace FindNationalityFunction;

public class Functions
{
[LambdaFunction]
public async Task<List<Country>> GetCountriesAsync([FromServices] IHttpClientFactory httpClientFactory, string name)
{
    var http = httpClientFactory.CreateClient("Nationality");

    var response = await http.GetFromJsonAsync<Response>($"https://api.nationalize.io/?name={name}");

    return response?.Countries switch
    {
        null or [] => new List<Country>(),
        var items => new List<Country>(items)
    };
}
}

public record Response(
    [property: JsonPropertyName("country")] Country[] Countries,
    [property: JsonPropertyName("name")] string Name
);

public record Country(
    [property: JsonPropertyName("country_id")] string CountryCode,
    [property: JsonPropertyName("probability")] double Probability
);

[LambdaStartup]
public class Startup
{
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddHttpClient("Nationality");
    }
}