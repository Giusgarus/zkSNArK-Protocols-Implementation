import java.io.BufferedWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

public class SudokuGenerator {

    public static void main(String[] args) {
        // Set the size of the matrix
        int n = 25; // You can replace with the desired value

        // Create an n x n matrix with all elements initialized to 0
        int[][] problem = new int[n][n];
        int[][] solution = new int[n][n];
        
        // Modify the Sudoku to make it solvable in a trivial way
        int count1=0;
        int j1=0;
        for(int i=0; i<n;i++) {
    		int remainder=(int) ((i%Math.sqrt(n)));
        	if(remainder==0) {
        		if(i!=0)
        			count1++;
        		j1=0+count1;
        	}
        	else {
        		j1=(int) (remainder*Math.sqrt(n)+count1);
        	}
        	if(j1==n)
        		j1=0;
        	problem[i][j1]=1;
        	int temp1=j1;
        	j1++;
        	if(j1==n)
        		j1=0;
        	while(j1!=temp1) {
        		problem[i][j1]=0;
        		j1++;
        		if(j1==n) 
        			j1=0;
            }
        }
        
        int count=0;
        int j=0;
        for(int i=0; i<n;i++) {
        	int k=2;
    		int remainder=(int) ((i%Math.sqrt(n)));
        	if(remainder==0) {
        		if(i!=0)
        			count++;
        		j=0+count;
        	}
        	else {
        		j=(int) (remainder*Math.sqrt(n)+count);
        	}
        	if(j==n)
        		j=0;
        	solution[i][j]=1;
        	int temp=j;
        	j++;
        	if(j==n)
        		j=0;
        	while(j!=temp) {
        		solution[i][j]=k;
        		k++;
        		j++;
        		if(j==n) 
        			j=0;
            }
        }

        
        SudokuStructure in=new SudokuStructure(problem,solution);

        // Save the matrix to a JSON file named input.json
        saveMatrixToJson2(in, "input.json");

        System.out.println("Matrix successfully saved to input.json.");
    }
    
    
    
    private static void saveMatrixToJson2(SudokuStructure in, String fileName) {
    	Gson gson = new GsonBuilder().setPrettyPrinting().create();
		
		// User data
		try (BufferedWriter writer = new BufferedWriter(new PrintWriter(fileName))) {
			Type matrixType = new TypeToken<SudokuStructure>(){}.getType();
			String input = gson.toJson(in, matrixType);
			writer.write(input);
			writer.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
}