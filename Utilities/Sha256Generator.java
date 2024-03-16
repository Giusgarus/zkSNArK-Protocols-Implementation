import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;

public class Sha256Generator {

    public static void main(String[] args) {
        // Set the size of the input
        int n = 5000; // You can replace it with the desired value

        // Create an array of n elements
        int[] solution = new int[n];

        // Initialize all elements to 1
        for(int i=0; i<n;i++) {
        	solution[i]=1;
        }
        

        // Save the array to a JSON file named input.json
        saveArrayToJson(solution, "input.json");

        System.out.println("Array successfully saved to input.json.");
    }
    
    
    
    
    private static void saveArrayToJson(int[] input, String fileName) {
    	Gson gson = new GsonBuilder().setPrettyPrinting().create();
		
		// User data
		try (BufferedWriter writer = new BufferedWriter(new PrintWriter(fileName))) {
			Type arrayType = new TypeToken<int[]>(){}.getType();
			String jsonInput = gson.toJson(input, arrayType);
			writer.write(jsonInput);
			writer.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
}

