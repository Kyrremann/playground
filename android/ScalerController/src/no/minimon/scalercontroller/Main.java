package no.minimon.scalercontroller;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

public class Main extends Activity implements OnItemClickListener {

	public static final String BLUETOOTH_ID = "BLUETOOTH_ID";

	private ListView btList;
	private BluetoothAdapter mBluetoothAdapter;
	private List<BluetoothDevice> mDevices;
	private List<String> mDevicesString;

	protected int selected;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
		setContentView(R.layout.activity_bluetooth_list);

		btList = (ListView) findViewById(R.id.btList);
		updateBluetoothAdapter();
		btList.setOnItemClickListener(this);
		
		// Register for broadcasts when a device is discovered
        IntentFilter filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
        this.registerReceiver(mReceiver, filter);
        
        // Register for broadcasts when discovery has finished
        filter = new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
        this.registerReceiver(mReceiver, filter);

        mDevices = new ArrayList<BluetoothDevice>();
        mDevicesString = new ArrayList<String>();
	}

	private void updateBluetoothAdapter() {
		btList.setAdapter(new ArrayAdapter<BluetoothDevice>(
				getApplicationContext(), android.R.layout.simple_list_item_1,
				getBluetoothDevices()));
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	private BluetoothDevice[] getBluetoothDevices() {
		mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		if (mBluetoothAdapter == null) {
			toastMessage(this, "No bluetooth adapter available");
		}

		if (!mBluetoothAdapter.isEnabled()) {
			Intent enableBluetooth = new Intent(
					BluetoothAdapter.ACTION_REQUEST_ENABLE);
			startActivityForResult(enableBluetooth, 0);
		}

		Set<BluetoothDevice> devices = mBluetoothAdapter.getBondedDevices();
		return devices.toArray(new BluetoothDevice[devices.size()]);
	}

	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position,
			long id) {
		Intent intent = new Intent(this, StandardController.class);
		intent.putExtra(BLUETOOTH_ID, getBluetoothAddress(position));
		startActivity(intent);
	}

	private String getBluetoothAddress(int position) {
		return ((BluetoothDevice) btList.getAdapter().getItem(position))
				.getAddress();
	}

	@Override
	public boolean onMenuItemSelected(int featureId, MenuItem item) {
		switch (item.getItemId()) {
		case R.id.action_refresh:
			updateBluetoothAdapter();
			break;
		case R.id.action_pair:
			setProgressBarIndeterminateVisibility(true);
			
			// pairBluetoothDevice();
			mDevices.clear();
			mBluetoothAdapter.startDiscovery();
			break;
		}

		return super.onMenuItemSelected(featureId, item);
	}

	private void pairBluetoothDevice() {
		AlertDialog.Builder builder = new Builder(this);
		builder.setTitle(R.string.title_pair);
		builder.setSingleChoiceItems(mDevicesString.toArray(new CharSequence[mDevicesString.size()]), 0, new OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				selected = which;
			}
		});
		builder.setPositiveButton("Pair", new OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				pairDevice(mDevices.get(selected));
			}
		});
		builder.setNeutralButton(android.R.string.cancel, new OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				
			}
		});
		builder.create().show();
	}
		
		public void pairDevice(BluetoothDevice device)
		{/*
		    String ACTION_PAIRING_REQUEST = "android.bluetooth.device.action.PAIRING_REQUEST";
		    Intent intent = new Intent(ACTION_PAIRING_REQUEST);
		    String EXTRA_DEVICE = "android.bluetooth.device.extra.DEVICE";
		    intent.putExtra(EXTRA_DEVICE, device);
		    String EXTRA_PAIRING_VARIANT = "android.bluetooth.device.extra.PAIRING_VARIANT";
		    int PAIRING_VARIANT_PIN = 1234;
		    intent.putExtra(EXTRA_PAIRING_VARIANT, PAIRING_VARIANT_PIN);
		    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		    startActivity(intent);*/
		/*	
		Intent intent = new Intent(BluetoothDevice.ACTION_PAIRING_REQUEST);
		intent.putExtra(EXTRA_DEVICE, device);
		int PAIRING_VARIANT_PIN = 272;
		intent.putExtra(BluetoothDevice.EXTRA_PAIRING_VARIANT, PAIRING_VARIANT_PIN);
		sendBroadcast(intent);
		*/
			/*
		Intent intent = new Intent(Settings.ACTION_BLUETOOTH_SETTINGS);
		startActivityForResult(intent, REQUEST_PAIR_DEVICE);
		*/
		}

	public static void toastMessage(Activity activity, String message) {
		Toast.makeText(activity.getApplicationContext(), message,
				Toast.LENGTH_SHORT).show();
	}
	
	// The BroadcastReceiver that listens for discovered devices and
    // changes the title when discovery is finished
    private final BroadcastReceiver mReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();

            // When discovery finds a device
            if (BluetoothDevice.ACTION_FOUND.equals(action)) {
                // Get the BluetoothDevice object from the Intent
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                // If it's already paired, skip it, because it's been listed already
                if (device.getBondState() != BluetoothDevice.BOND_BONDED) {
                	mDevices.add(device);
                	mDevicesString.add(device.getName() + "\n" + device.getAddress());
                    // mNewDevicesArrayAdapter.add(device.getName() + "\n" + device.getAddress());
                	Toast.makeText(getApplicationContext(), device.getName() + "\n" + device.getAddress(), Toast.LENGTH_SHORT).show();
                }
            // When discovery is finished, change the Activity title
            } else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
                setProgressBarIndeterminateVisibility(false);
                // setTitle(R.string.select_device);
                // if (mNewDevicesArrayAdapter.getCount() == 0) {
                    // String noDevices = getResources().getText().toString();
                    // mNewDevicesArrayAdapter.add("No devices found");
               // }
                pairBluetoothDevice();
            	Toast.makeText(getApplicationContext(), "Done", Toast.LENGTH_SHORT).show();
            }
        }
    };
    


    @Override
    protected void onDestroy() {
        super.onDestroy();

        // Make sure we're not doing discovery anymore
        if (mBluetoothAdapter != null) {
            mBluetoothAdapter.cancelDiscovery();
        }
         // Unregister broadcast listeners
        this.unregisterReceiver(mReceiver);
    }

}
