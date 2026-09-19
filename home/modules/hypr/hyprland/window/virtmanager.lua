hl.window_rule({
	match = {
		initial_class = "^\\.virt-manager-wrapped$",
	},
	float = true,
})

-- The main virt machine manager should float,
-- but guest should not `<name of the vm> on on QEMU/KVM`.
hl.window_rule({
	match = {
		initial_title = "^.* on QEMU/KVM$",
	},
	float = false,
})
