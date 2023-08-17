import * as functions from "firebase-functions";
import axios, {AxiosError} from "axios";

export const wordsAPI = functions.https.onRequest(async (request, response) => {
  try {
    const word = request.query.word;
    const wordsAPIResponse = await axios.get(
        `https://wordsapiv1.p.rapidapi.com/words/${word}`,
        {
          headers: {
            "Content-Type": "application/json",
            "X-RapidAPI-Key": process.env.WORDS_API_KEY,
            "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com",
          },
        }
    );
    response.status(200).json(wordsAPIResponse.data);
  } catch (error) {
    if (error instanceof AxiosError) {
      const responseData = error.response?.data;
      if (response) {
        response.status(200).json(responseData);
      }
    } else {
      response.status(500).json({error: error});
    }
  }
});
