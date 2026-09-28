/*
 *  SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

package org.kde.kirigamiaddons.dateandtime;

import android.app.TimePickerDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.app.DialogFragment;
import android.app.Activity;

import java.util.Calendar;

public class TimePicker extends DialogFragment
        implements TimePickerDialog.OnTimeSetListener {

    private Activity activity;
    private long initialTime;
    private boolean resettable;
    private String resetLabel;

    private native void timeSelected(int hours, int minutes);
    private native void cancelled();
    private native void reset();

    public TimePicker(Activity activity, long initialTime, boolean resettable, String resetLabel) {
        super();
        this.activity = activity;
        this.initialTime = initialTime;
        this.resettable = resettable;
        this.resetLabel = resetLabel;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(initialTime);
        TimePickerDialog dialog = new TimePickerDialog(activity, this, cal.get(Calendar.HOUR_OF_DAY), cal.get(Calendar.MINUTE), true);
        if (resettable) {
            dialog.setButton(DialogInterface.BUTTON_NEUTRAL, resetLabel, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface d, int which) {
                    reset();
                }
            });
        }
        return dialog;
    }

    public void onTimeSet(android.widget.TimePicker view, int hourOfDay, int minute) {
        timeSelected(hourOfDay, minute);
    }

    @Override
    public void onCancel(DialogInterface dialog) {
        cancelled();
    }

    public void doShow() {
        show(activity.getFragmentManager(), "timePicker");
    }
}
