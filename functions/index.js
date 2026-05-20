/**
 * LikeALocal Cloud Functions
 * Secure AI chat endpoint using Gemini API
 */
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {GoogleGenerativeAI} = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

exports.askLocalGuide = onCall({
  region: "us-central1",
  enforceAppCheck: false,
}, async (request) => {
  if (!request.auth) {
    throw new HttpsError(
        "unauthenticated",
        "Login required to use LocalGuide AI",
    );
  }

  try {
    const {city, query, destContext} = request.data;

    if (!city || !query) {
      throw new HttpsError(
          "invalid-argument",
          "City and query are required",
      );
    }

    let context = "No specific destination details provided";
    if (destContext) {
      context = "View: " + destContext.view +
          ", Stay: " + destContext.stay +
          ", Activity: " + destContext.act;
    }

    const prompt = "You are LocalGuide AI.\n" +
        "User is asking about " + city + ".\n" +
        "Context: " + context + "\n" +
        "Question: \"" + query + "\"";

    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash",
      generationConfig: {
        temperature: 0.7,
        maxOutputTokens: 150,
      },
    });

    const result = await model.generateContent(prompt);
    const responseText = result.response.text().trim();

    return {response: responseText};
  } catch (error) {
    if (error.message && error.message.includes("quota")) {
      throw new HttpsError(
          "internal",
          "AI service unavailable",
      );
    }
    throw new HttpsError(
        "internal",
        "Failed to generate AI response",
    );
  }
});

exports.healthCheck = onCall({region: "us-central1"}, () => {
  return {
    status: "ok",
    timestamp: new Date().toISOString(),
    region: "us-central1",
  };
});
