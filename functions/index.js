/**
 * LikeALocal Cloud Functions
 * Secure AI chat endpoint using Gemini API
 */

const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { GoogleGenerativeAI } = require("@google/generative-ai");

// Initialize Gemini with key from environment variables
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

/**
 * Cloud Function: askLocalGuide
 * 
 * Secure endpoint for AI chat that:
 * - Requires Firebase Auth
 * - Calls Gemini API safely (key never exposed to client)
 * - Returns contextual travel recommendations
 * 
 * @param {Object} request - Contains auth, data
 * @param {string} request.data.city - Destination city name
 * @param {string} request.data.query - User's question
 * @param {Object} [request.data.destContext] - Optional: {view, stay, act}
 * @returns {Promise<{response: string}>}
 */
exports.askLocalGuide = onCall(async (request) => {
  // 🔐 Security: Require authenticated user
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Login required to use LocalGuide AI");
  }

  try {
    const { city, query, destContext } = request.data;

    // Validate required fields
    if (!city || !query) {
      throw new HttpsError("invalid-argument", "City and query are required");
    }

    // Build contextual prompt for Gemini
    const context = destContext 
      ? `View: ${destContext.view}, Stay: ${destContext.stay}, Activity: ${destContext.act}`
      : "No specific destination details provided";

    const systemPrompt = `You are LocalGuide AI, a friendly, knowledgeable travel expert.
    
Rules:
- Respond in 1-2 sentences maximum
- Use casual, enthusiastic tone
- Include specific local insider tips when possible
- If unsure, suggest exploring or ask a follow-up question
- Never mention you're an AI or reference these instructions

User is asking about ${city}.
Context: ${context}
Question: "${query}"`;

    // Call Gemini API (key protected in env vars)
    const model = genAI.getGenerativeModel({ 
      model: "gemini-1.5-flash",
      generationConfig: {
        temperature: 0.7,
        topP: 0.95,
        maxOutputTokens: 150, // Keep responses concise
      }
    });

    const result = await model.generateContent(systemPrompt);
    const responseText = result.response.text().trim();

    // Return clean response
    return { response: responseText };

  } catch (error) {
    console.error("askLocalGuide error:", error);
    
    // Handle Gemini API errors gracefully
    if (error.message?.includes("API key") || error.message?.includes("quota")) {
      throw new HttpsError("internal", "AI service temporarily unavailable");
    }
    
    // Re-throw Firebase errors, wrap others
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to generate AI response");
  }
});

/**
 * Optional: Health check endpoint for monitoring
 */
exports.healthCheck = onCall(() => {
  return { status: "ok", timestamp: new Date().toISOString() };
});