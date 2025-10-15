<?
    require_once 'vendor/autoload.php';
    
    error_reporting(E_ALL ^ E_DEPRECATED);
    
    // error_log($path);

    if(!tao_install_utils_System::isTAOInstalled()){
    
        header("location:tao/install");
    
    } else {
    
        $bootStrap = new oat\tao\model\mvc\Bootstrap(__DIR__.'/config/generis.conf.php');
        $bootStrap->start();
        $bootStrap->dispatch();
    
    }