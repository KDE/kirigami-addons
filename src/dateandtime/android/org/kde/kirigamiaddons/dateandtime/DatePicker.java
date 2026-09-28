/*
 *  SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

package org.kde.kirigamiaddons.dateandtime;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.app.DialogFragment;
import android.app.Activity;

import java.util.Calendar;

public class DatePicker extends DialogFragment implements DatePickerDialog.OnDateSetListener {

    private Activity activity;
    private long initialDate;
    private boolean resettable;
    private String resetLabel;

    private native void dateSelected(int day, int month, int year);
    private native void cancelled();
    private native void reset();

    public DatePicker(Activity activity, long initialDate, boolean resettable, String resetLabel) {
        super();
        this.activity = activity;
        this.initialDate = initialDate;
        this.resettable = resettable;
        this.resetLabel = resetLabel;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(initialDate);
        DatePickerDialog dialog = new DatePickerDialog(activity, this, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH));
        android.widget.DatePicker picker = dialog.getDatePicker();
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

    @Override
    public void onCancel(DialogInterface dialog) {
        cancelled();
    }

    @Override
    public void onDateSet(android.widget.DatePicker view, int year, int month, int day) {
        // Android reports month starting with 0
        month++;
        dateSelected(day, month, year);
    }

    public void doShow() {
        show(activity.getFragmentManager(), "datePicker");
    }
}
