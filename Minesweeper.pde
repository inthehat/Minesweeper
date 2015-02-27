public static int NUM_ROWS=16;
public static int NUM_COLS=16;
public static int NUM_BOMBS=40;
public static int SIZE_WIDTH=400;
public static int SIZE_HEIGHT=400;
public static int SIZE_MESSAGE=30;
public boolean isLost=false;
public boolean noBombs=true;
private MSButton[][] buttons=new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs=new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
private boolean newGame=false;
private int n=0;
private boolean clickable=false;

void setup ()
{
    size(SIZE_WIDTH, SIZE_HEIGHT);
    textAlign(CENTER,CENTER);
    textSize(11);
    stroke(0);
    smooth();
    // make the manager
    Interactive.make( this );
    
    for(int x=0;x<NUM_ROWS;x++)
    {
        for(int y=0;y<NUM_COLS;y++)
        {
            buttons[x][y] = new MSButton(x,y);
        }
    }
}
public void setBombs(int rr, int cc)
{
    if(rr-2 > 0 && cc-2 > 0) {bombs.add(buttons[rr-2][cc-2]);}
    if(rr-2 > 0 && cc+2 < NUM_COLS) {bombs.add(buttons[rr-2][cc+2]);}
    if(rr+2 < NUM_ROWS && cc-2 > 0) {bombs.add(buttons[rr+2][cc-2]);}
    if(rr+2 < NUM_ROWS && cc+2 < NUM_COLS) {bombs.add(buttons[rr+2][cc+2]);}
    for(int b=NUM_BOMBS;b>0;b--)
    {
        int r=(int)(Math.random()*NUM_ROWS);
        int c=(int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[r][c]) && (!((r>=rr-1)&&(r<=rr+1)) || !((c>=cc-1)&&(c<=cc+1))) && !((r==rr-2)&&(c>=cc-1 && c<=cc+1)) && !((r==rr+2)&&(c>=cc-1 && c<=cc+1)) && !((c==cc-2)&&(r>=rr-1 && r<=rr+1)) && !((c==cc+2)&&(r>=rr-1 && r<=rr+1)))
        {
            bombs.add(buttons[r][c]);
        }
        else
        {
            b++;
            
        }
    }
}

public void draw ()
{
    background( 0 );
    if(noBombs)
    {
        n++;
        if(n>2) 
        {
            n=2;
            clickable=true;
        }
    }
    if(isWon())
    {
        displayWinningMessage();
        newGame=true;
    }
    else if(isLost==true)
    {
        displayLosingMessage();
        for(int x=0;x<NUM_ROWS;x++)
        {
            for(int y=0;y<NUM_COLS;y++)
            {
                buttons[x][y].mousePressed();
            }
        }
        newGame=true;
        noLoop();
    }
}
public boolean isWon()
{
    for(int x=0;x<NUM_ROWS;x++)
    {
        for(int y=0;y<NUM_COLS;y++)
        {
            if(buttons[x][y].isClicked()==false)
            {
                if(!(bombs.contains(buttons[x][y]))) {return false;}
            }
        }
    } 
    return true;
}
public void displayLosingMessage()
{
    fill(255);
    textSize(14);
    text("",width/2,height-(SIZE_MESSAGE/2));

}
public void displayWinningMessage()
{
    fill(255);
    textSize(14);
    text("",width/2,height-(SIZE_MESSAGE/2));

}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = (int)(SIZE_WIDTH/NUM_COLS);
        height = (int)(SIZE_HEIGHT/NUM_ROWS);
        r = rr;
        c = cc; 
        x = (int)c*(int)width;
        y = (int)r*(int)height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager 
    public void setClicked(boolean b)
    {
        clicked=b;
    }
    public void setMarked(boolean b)
    {
        marked=b;
    }
    public void mousePressed () 
    {
        if(mouseButton==LEFT)
        {
            if(newGame==false && clickable)
            {
                if(isWon()==false)
                {
                    if(noBombs==true)
                    {
                        noBombs=false;
                        setBombs(r,c);
                    } 
                    if(marked==false)
                    {
                        clicked=true;
                        if(bombs.contains(this))
                        {
                            if(isLost==false)
                            {
                                isLost=true;
                            }
                        }
                        else if(countBombs(r,c)>0)
                        {
                            if(!bombs.contains(this))
                            {
                                setLabel(""+countBombs(r,c));
                            }
                        }
                        else
                        {
                            for(int row=r-1;row<=r+1;row++)
                            {
                                for(int col=c-1;col<=c+1;col++)
                                {
                                    if(isValid(row,col) && !(buttons[row][col].isClicked()) && !(buttons[row][col].isMarked()))
                                    {
                                        buttons[row][col].mousePressed();
                                    }
                                }
                            }
                        }
                    }                
                } 
                if(!marked)
                {
                    clicked=true;
                }
            } 
        }
        if(mouseButton==RIGHT)
        {
            if(noBombs==false)
            {
                if(isWon()==false)
                {
                    if(isLost==false)
                    {
                        if(clicked==false)
                        {
                            marked=!marked;
                        }
                    }
                }
            }
        }
        //println(r+" "+c+" clicked: "+clicked);
        //println(r+" "+c+" marked: "+marked);
        //println("newGame: "+newGame);
        //println("isLost: "+isLost);
        //println("noBombs: "+noBombs);
        if(newGame==true)
        {
            isLost=false;
            noBombs=true;
            clickable=false;
            n=0;
            buttons=new MSButton[NUM_ROWS][NUM_COLS];
            for(int x=0;x<NUM_ROWS;x++)
            {
                for(int y=0;y<NUM_COLS;y++)
                {
                    buttons[x][y] = new MSButton(x,y);
                }
            }
            for(int x=0;x<NUM_ROWS;x++)
            {
                for(int y=0;y<NUM_COLS;y++)
                {
                    buttons[x][y].setClicked(false);
                    buttons[x][y].setMarked(false);
                }
            }
            bombs=new ArrayList <MSButton> ();
            newGame=false;
            loop();
        }
    }

    public void draw () 
    {   
        if(clicked)
        {
            if(bombs.contains(this))
            {
                fill(255,0,0);
            }
            else 
            {
                fill(220);    
            }
        }
        else if(marked)
        {
            if((isWon() || isLost) && bombs.contains(this))
            {
                fill(255,255,0);
            }
            else
            {
                fill(0,255,0);    
            }
        }
        else if (isWon()) 
        {
            fill(0,255,0);    
        }
        else
        {
            fill(100);    
        }

        rect(x, y, width, height);
        fill(0);
        textSize(11);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String nLabel)
    {
        label = nLabel;
    }
    public boolean isValid(int r, int c)
    {
        if((r<0 || r>NUM_ROWS-1) || (c<0 || c>NUM_COLS-1))
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int r=row-1;r<=row+1;r++)
        {
            for(int c=col-1;c<=col+1;c++)
            {
                if(isValid(r,c))
                {
                    if(bombs.contains(buttons[r][c]))
                    {
                        numBombs++;
                    }
                }
            }
        }
        return numBombs;
    }
}
