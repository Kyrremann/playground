package no.minimon.scalercontroller;

import java.io.IOException;
import java.io.OutputStream;
import java.util.UUID;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.Switch;

public class StandardController extends Activity implements
		OnCheckedChangeListener, OnClickListener {

	private BluetoothDevice mmDevice;
	private BluetoothSocket mmSocket;
	private OutputStream mmOutputStream;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_control_panel);

		Switch switchWidget = (Switch) findViewById(R.id.switch_light_front);
		switchWidget.setOnCheckedChangeListener(this);
		switchWidget = (Switch) findViewById(R.id.switch_light_front_fog);
		switchWidget.setOnCheckedChangeListener(this);
		switchWidget = (Switch) findViewById(R.id.switch_light_back);
		switchWidget.setOnCheckedChangeListener(this);
		switchWidget = (Switch) findViewById(R.id.switch_light_roof);
		switchWidget.setOnCheckedChangeListener(this);
		Button button = (Button) findViewById(R.id.button1);
		button.setOnClickListener(this);
		button = (Button) findViewById(R.id.button2);
		button.setOnClickListener(this);
		button = (Button) findViewById(R.id.button3);
		button.setOnClickListener(this);

		try {
			openBT(getBluetoothBasedOnAddress(getIntent().getStringExtra(
					Main.BLUETOOTH_ID)));
		} catch (IOException e) {
			Main.toastMessage(this, "Problem connectiong to bluetooth");
			e.printStackTrace();
		}
	}

	@Override
	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.button1:
				sendData('W', true);
				break;
			case R.id.button2:
				sendData('w', false);
				break;
			case R.id.button3:
				sendData('S', true);
				break;
			}
		} catch (IOException e) {
			Main.toastMessage(this, "Something went wrong in the communication");
		}
	}

	@Override
	public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
		try {
			switch (buttonView.getId()) {
			case R.id.switch_light_front:
				sendData('F', isChecked);
				break;
			case R.id.switch_light_front_fog:
				sendData('H', isChecked);
				break;
			case R.id.switch_light_back:
				sendData('B', isChecked);
				break;
			case R.id.switch_light_roof:
				sendData('R', isChecked);
				break;
			}
		} catch (IOException ex) {
			Main.toastMessage(this, "Something went wrong in the communication");
		}
	}

	void sendData(char cmd, boolean isChecked) throws IOException {
		if (!isChecked) {
			cmd = Character.toLowerCase(cmd);
		}
		mmOutputStream.write(cmd);
		Log.d("BT", "Char sent: " + cmd);
	}

	void closeBT() throws IOException {
		mmOutputStream.close();
		mmSocket.close();
	}

	private void openBT(BluetoothDevice device) throws IOException {
		if (device == null)
			return;

		mmDevice = device;
		UUID uuid = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb"); // Standard
																				// //SerialPortService
																				// ID
		mmSocket = mmDevice.createRfcommSocketToServiceRecord(uuid);
		mmSocket.connect();
		mmOutputStream = mmSocket.getOutputStream();
	}

	private BluetoothDevice getBluetoothBasedOnAddress(String address) {
		BluetoothAdapter bluetoothAdapter = BluetoothAdapter
				.getDefaultAdapter();
		if (bluetoothAdapter == null) {
			Main.toastMessage(this, "No bluetooth adapter available");
			finish();
			return null;
		}

		if (!bluetoothAdapter.isEnabled()) {
			Intent enableBluetooth = new Intent(
					BluetoothAdapter.ACTION_REQUEST_ENABLE);
			startActivityForResult(enableBluetooth, 0);
		}

		for (BluetoothDevice device : bluetoothAdapter.getBondedDevices()) {
			if (device.getAddress().equals(device)) {
				return device;
			}

		}

		finish();
		Main.toastMessage(this, "Can't find bluetooth device");
		return null;
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		try {
			closeBT();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
