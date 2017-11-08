package no.uio.ifi.sonen.ai.dotwars;

import java.awt.Dimension;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRootPane;

public class Gfx extends JFrame {

	private static final long serialVersionUID = 1L;
	private JRootPane rootPane;
	private JPanel panel;
	
	/** Size of a unit square on the map. */
    public static final int UNIT   = 24;

    /** Number of horizontal/vertical squares. */
    public static final int XUNIT  = 50;
    public static final int YUNIT  = 30;

    /** Pixel width/height of the screen. */
    public static final int WIDTH  = UNIT * XUNIT;
    public static final int HEIGHT = UNIT * YUNIT;


	public Gfx() {
		super("Dot Wars");
		
		rootPane = getRootPane();
		panel = new JPanel(true);
		rootPane.add(panel);
		
		panel.setSize(WIDTH, HEIGHT);
		
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setMinimumSize(new Dimension(WIDTH, HEIGHT));
		setLocationRelativeTo(null);
		setResizable(false);
		setUndecorated(true);
		setVisible(true);
		createBufferStrategy(2);
		
	}
}

