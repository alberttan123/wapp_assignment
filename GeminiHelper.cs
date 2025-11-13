using System;
using System.Configuration;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

public static class GeminiHelper
{
    private static readonly HttpClient http = new HttpClient();
    private static readonly string apiKey = ConfigurationManager.AppSettings["GEMINI_API_KEY"];

    public static async Task<string> GeminiPrompt(string prompt, string systemInstruction)
    {
        string url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

        var payload = new
        {
            system_instruction = new
            {
                parts = new[]
                {
                new { text = systemInstruction }
            }
            },
            contents = new[]
            {
            new
            {
                parts = new[]
                {
                    new { text = prompt }
                }
            }
        }
        };

        string json = JsonConvert.SerializeObject(payload);

        var req = new HttpRequestMessage(HttpMethod.Post, url);
        req.Headers.Add("x-goog-api-key", apiKey);
        req.Content = new StringContent(json, Encoding.UTF8, "application/json");

        HttpResponseMessage resp = await http.SendAsync(req);
        string body = await resp.Content.ReadAsStringAsync();

        if (!resp.IsSuccessStatusCode)
            return $"ERROR: {resp.StatusCode}\n{body}";

        return body;
    }


    public static string TransformGeminiResponse(string rawJson)
    {
        try
        {
            dynamic obj = JsonConvert.DeserializeObject(rawJson);

            string output = obj.candidates[0].content.parts[0].text;

            if (String.IsNullOrWhiteSpace(output))
                return "[Empty Gemini Response]";

            string text = output;

            // --- Clean markdown formatting ---
            // Remove **bold** markup
            text = text.Replace("**", "");

            // Remove *italic* markup
            text = text.Replace("*", "");

            // --- Clean escaped sequences ---
            // Convert \" → "
            text = text.Replace("\\\"", "\"");

            // Convert \\ → \
            text = text.Replace("\\\\", "\\");

            // Trim leading/trailing quotes if present
            text = text.Trim();
            if (text.StartsWith("\"") && text.EndsWith("\""))
                text = text.Substring(1, text.Length - 2);

            return text.Trim();
        }
        catch (Exception ex)
        {
            return $"Transformation Error: {ex.Message}";
        }
    }


    public static async Task<string> Gemini(string prompt, string systemConfig) 
    {
        string raw = await GeminiPrompt(prompt, systemConfig);
        string text = TransformGeminiResponse(raw);
        return text;
    }
}