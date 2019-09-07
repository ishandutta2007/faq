##### Methods



##### Testing

pages for testing fingerprinting

 * https://panopticlick.eff.org

sample of resluts

| Browser Characteristic      | bits of identifying information | one in x browsers have this value |
|-----------------------------|---------------------------------|-----------------------------------|
| User Agent                  | 11.57                           | 3032.51                           |
| HTTP_ACCEPT Headers         | 11.27                           | 2463.91                           |
| Browser Plugin Details      | 3.11                            | 8.62                              |
| Time Zone                   | 2.37                            | 5.18                              |
| Screen Size and Color Depth | 5.84                            | 57.13                             |
| System Fonts                | 4.61                            | 24.37                             |
| Are Cookies Enabled?        | 0.24                            | 1.18                              |
| Limited supercookie test    | 0.36                            | 1.28                              |
| Hash of canvas fingerprint  | 7.79                            | 221.48                            |
| Hash of WebGL fingerprint   | 7.48                            | 178.87                            |
| DNT Header Enabled?         | 0.8                             | 1.74                              |
| Language                    | 0.98                            | 1.97                              |
| Platform                    | 1.43                            | 2.69                              |
| Touch Support               | 0.73                            | 1.65                              |

##### Defence

chrome extensions:

 * Defending against canvas fingerprinting by reporting a fake value. 
 [Canvas Fingerprint Defender](https://chrome.google.com/webstore/detail/canvas-fingerprint-defend/lanfdkkpgfjfdikkncbnojekcppdebfp)

 * Spoofs & Mimics User-Agent strings.
 [User-Agent Switcher for Chrome](https://chrome.google.com/webstore/detail/user-agent-switcher-for-c/djflhoibgkdhkhhcedjiklpkjnoahfmg)
