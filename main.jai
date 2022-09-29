#import "Basic";
#import "Compiler";
#import "File_Utilities";
#import "String";

build :: () {
    context.allocator = __temporary_allocator;

    current_workspace := get_current_workspace();
    // current_build_options := get_build_options();
    // current_build_options.output_type = .NO_OUTPUT;
    set_build_options_dc(.{do_output=false}, current_workspace);
    // set_build_options(current_build_options, current_workspace);

    workspace := compiler_create_workspace("Koda Ground Generator");
    build_options := get_build_options(workspace);
    build_options.output_type = .EXECUTABLE;
    build_options.output_executable_name = "main";
    build_options.temporary_storage_size = 2097152;
    build_options.import_path = .["C:/jai/modules", #run tprint("%../", #filepath)];
    print("Module folders: %\n", build_options.import_path);
    set_build_options(build_options, workspace);
    set_working_directory(#filepath);

    compiler_begin_intercept(workspace);
    defer compiler_end_intercept(workspace);

    // source files
    files := file_list(tprint("%src", #filepath), true);
    // add_build_file(tprint("%KodaFluid.jai", #filepath), workspace);
    for file : files {
         // skip non-jai source files
        if !ends_with(file, ".jai") {
            continue;
        }

        print("Build file: %\n", file);
        add_build_file(file, workspace);
    }
    
    default_check_message :: (message: *Message) -> valid: bool, complete: bool {
        if !message return false, false;
        // print("Default check message: %\n", << message);
        if message.kind == .COMPLETE return false, true;
        return true, false;
    }

    check_message := default_check_message;
    if build_options.user_data_u64 {
        check_message = << cast(*type_of(default_check_message)) build_options.user_data_u64;
    }

    while true {
        message := compiler_wait_for_message();

        valid, complete := check_message(message);
        if complete break;
        if !valid continue;

        // print("Compiler message: %\n", << message);
    }
}

#run build();