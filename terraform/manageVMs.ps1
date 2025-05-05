$ResourceGroupName = "gowriRG"
# Login with managed identity or interactive login if needed
# Uncomment below if you need login, otherwise assume context is set
#Connect-AzAccount -UseDeviceAuthentication

# Get all VMs in the specified resource group
$vmList = Get-AzVM -ResourceGroupName $ResourceGroupName

foreach ($vm in $vmList) {
    # Get the instance view that contains the current power state and other info
    $instanceView = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $vm.Name -Status

    # Get the power state (e.g., "VM running", "VM stopped")
    $powerState = ($instanceView.Statuses | Where-Object { $_.Code -like 'PowerState/*' }).DisplayStatus

    # Check if VM is running
    if ($powerState -eq 'VM running') {
        # Check if it's a spot instance
        # Spot VMs have EvictionPolicy set and Priority = 'Spot'
        $priority = $vm.Priority

        if ($priority -eq 'Spot') {
            Write-Output "Deleting Spot VM: $($vm.Name)"
            # Delete the VM (this deletes the VM and its compute resources, but disks may persist)
            Remove-AzVM -ResourceGroupName $ResourceGroupName -Name $vm.Name -Force
        }
        else {
            Write-Output "Stopping (deallocating) normal VM: $($vm.Name)"
            # Stop and deallocate the VM
            Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $vm.Name -Force -NoWait
        }
    }
    else {
        Write-Output "VM $($vm.Name) is not running ($powerState), skipping."
    }
}
