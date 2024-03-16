import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;

public class HamiltonGenerator {

    public static void main(String[] args) {
        // Set the size of the matrix
        int n = 15; // You can replace it with the desired value

        
        int[][] graph = new int[n][n];
        int[] solution = new int[n];
        
        // Create an n x n matrix with all elements initialized to 0 except the one indicating the next node
        for(int i=0; i<n;i++) {
        	for(int j=0; j<n;j++) {
        		if(i==n-1)
        			graph[i][0]=1;
        		else if(j==i+1)
        			graph[i][j]=1;
        		else
        			graph[i][j]=0;
            	
            }
        }
        
        for(int i=0; i<n;i++) {
        	solution[i]=i+1;
        }
        
        HamStructure input=new HamStructure(graph,solution);

        // Save the matrix to a JSON file named input.json
        saveMatrixToJson2(input, "input.json");

        System.out.println("Matrix successfully saved to input.json.");
    }
    
    
    
    
    private static void saveMatrixToJson2(HamStructure input, String fileName) {
    	Gson gson = new GsonBuilder().setPrettyPrinting().create();
        
        // User data
        try (BufferedWriter writer = new BufferedWriter(new PrintWriter(fileName))) {
            Type matrixType = new TypeToken<HamStructure>(){}.getType();
            String inputJson = gson.toJson(input, matrixType);
            writer.write(inputJson);
            writer.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

