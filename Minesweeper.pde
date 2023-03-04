import de.bezier.guido.*;
public static final int NUM_ROWS = 50;
public static final int NUM_COLS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public static final int NUM_MINES = 250;
void setup ()
{
  size(1000, 1000);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i<NUM_ROWS; i++) {
    for (int j = 0; j<NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }


  setMines();
}
public void setMines()
{
  while (mines.size()<NUM_MINES) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true) {
    displayWinningMessage();
  }
  if (isLose()) {
    displayLosingMessage();
  }
}
public boolean isWon()
{
  int flags =0;
  for (int i = 0; i<mines.size(); i++) {
    if (mines.get(i).isFlagged()) {
      flags++;
    }
  }
  if (flags == mines.size()) {
    return true;
  }  
  return false;
}

public boolean isLose() {
  for (int i = 0; i<mines.size(); i++) {
    if (mines.get(i).isPressed()) {
      return true;
    }
  }
  return false;
}

public void displayLosingMessage()
{
  buttons[25][23].setLabel("L");
  buttons[25][24].setLabel("O");
  buttons[25][25].setLabel("S");
  buttons[25][26].setLabel("E");
  buttons[25][27].setLabel("R");
}
public void displayWinningMessage()
{
  buttons[25][22].setLabel("W");
  buttons[25][23].setLabel("I");
  buttons[25][24].setLabel("N");
  buttons[25][25].setLabel("N");
  buttons[25][26].setLabel("E");
  buttons[25][27].setLabel("R");
}
public boolean isValid(int r, int c)
{
  return r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  if(isValid(row-1,col-1) && mines.contains(buttons[row-1][col-1])){
       numMines++;
  }
  if(isValid(row-1,col) && mines.contains(buttons[row-1][col])){
       numMines++;
  }
  if(isValid(row-1,col+1) && mines.contains(buttons[row-1][col+1])){
       numMines++;
  }
  if(isValid(row,col+1) && mines.contains(buttons[row][col+1])){
       numMines++;
  }
  if(isValid(row+1,col+1) && mines.contains(buttons[row+1][col+1])){
       numMines++;
  }
  if(isValid(row+1,col) && mines.contains(buttons[row+1][col])){
       numMines++;
  }
  if(isValid(row+1,col-1) && mines.contains(buttons[row+1][col-1])){
       numMines++;
  }
  if(isValid(row,col-1) && mines.contains(buttons[row][col-1])){
      numMines++;
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean pressed, flagged;
  private String myLabel;

  public boolean isFlagged() {
    return flagged;
  }
  public boolean isPressed() {
    return pressed;
  }

  public MSButton ( int row, int col )
  {
    width = 1000/NUM_COLS;
    height = 1000/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = pressed = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (mouseButton == LEFT) {
      pressed = true;
    }
    if (mouseButton == RIGHT) {
      flagged = !flagged;
    } else if (countMines(myRow, myCol)>0) {
      if (isFlagged()==false) {
        myLabel = "" + countMines(myRow, myCol);
      }
    } else {
      if (isValid(myRow-1, myCol) && !buttons[myRow-1][myCol].pressed)
        buttons[myRow-1][myCol].mousePressed();
      if (isValid(myRow-1,myCol-1) && !buttons[myRow-1][myCol-1].pressed)
        buttons[myRow-1][myCol-1].mousePressed();
      if (isValid(myRow-1, myCol+1) && !buttons[myRow-1][myCol+1].pressed)
        buttons[myRow-1][myCol+1].mousePressed();
      if (isValid(myRow, myCol-1) && !buttons[myRow][myCol-1].pressed)
        buttons[myRow][myCol-1].mousePressed();
      if (isValid(myRow+1, myCol-1) && !buttons[myRow+1][myCol-1].pressed)
        buttons[myRow+1][myCol-1].mousePressed();
      if (isValid(myRow+1, myCol) && !buttons[myRow+1][myCol].pressed)
        buttons[myRow+1][myCol].mousePressed();
      if (isValid(myRow+1, myCol+1) && !buttons[myRow+1][myCol+1].pressed)
        buttons[myRow+1][myCol+1].mousePressed();
      if (isValid(myRow, myCol+1) && !buttons[myRow][myCol+1].pressed)
        buttons[myRow][myCol+1].mousePressed();
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if (pressed && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (pressed)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
}
