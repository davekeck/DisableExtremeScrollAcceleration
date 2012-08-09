#import <Foundation/Foundation.h>

int main(int argc, char *argv[])
{
    /* No memory management cause baby we too cool for that */
    io_iterator_t matchingServicesIterator = MACH_PORT_NULL;
    kern_return_t kernStatus = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceNameMatching("IOHIDSystem"), &matchingServicesIterator);
        if (kernStatus != KERN_SUCCESS || !matchingServicesIterator)
        {
            NSLog(@"Failed to disable extreme scroll acceleration");
            return 1;
        }
    
    io_service_t currentService = MACH_PORT_NULL;
    while ((currentService = IOIteratorNext(matchingServicesIterator)))
    {
        kernStatus = IORegistryEntrySetCFProperty(currentService, CFSTR("HIDScrollCountMinDeltaToStart"), @(1000));
            if (kernStatus != KERN_SUCCESS)
            {
                NSLog(@"Failed to disable extreme scroll acceleration for IOHIDSystem: %p", (void *)currentService);
                continue;
            }
    }
    
    NSLog(@"Disabled extreme scroll acceleration");
    return 0;
}