/**
 * Your application code goes here
 */
package userclasses;

import com.codename1.ui.list.DefaultListModel;
import generated.StateMachineBase;
import com.codename1.ui.*; 
import com.codename1.ui.events.*;
import com.codename1.ui.util.Resources;
import no.minimon.app.rivetwarsrules.utils.SimpleJSONParser;

import java.util.Map;
import java.util.Objects;

public class StateMachine extends StateMachineBase {

    Map<String, Object> mainList;

    public StateMachine(String resFile) {
        super(resFile);
        // do not modify, write code in initVars and initialize class members there,
        // the constructor might be invoked too late due to race conditions that might occur
    }
    
    /**
     * this method should be used to initialize variables instead of
     * the constructor/class scope to avoid race conditions
     */
    protected void initVars(Resources res) {
        mainList = SimpleJSONParser.getMeSomeJson(res, "rules.json");
    }

    @Override
    protected boolean initListModelMainList(List cmp) {
        cmp.setModel(new DefaultListModel(mainList.keySet()));
        return true;
    }

    @Override
    protected void onMain_MainListAction(Component c, ActionEvent event) {
        System.out.println("click");
        System.out.println(event);
        System.out.println(c);
    }
}
