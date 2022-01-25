/////////////////////////////////////////////////////////////////////
////                              __                             ////
////                             |  |                            ////
////                             |  |                            ////
////                       ___   |  |                            ////
////                   ___ \  \__/  /                            ////
////                  /  /  \______/                             ////
////                 /  /________________                        ////
////                |   _________________|                       ////
////                \  \                                         ////
////                 \__\ John M Mower                           ////
////                                                             ////
//// Copyright (C) 2017 - 2022 Susitronix, LLC                   ////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/init.h>
#include <linux/ioctl.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/interrupt.h>
#include <linux/uaccess.h>
#include <linux/cdev.h>
#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <linux/fs.h>

#include "genericio.h"
#include "etharbtx_ioctl.h"

#define ETHTX_SRCIP_REG    0x00000010
#define ETHTX_DSTIP_REG    0x00000018
#define ETHTX_SRCMAC_LREG  0x00000020
#define ETHTX_SRCMAC_HREG  0x00000024
#define ETHTX_DSTMAC_LREG  0x0000002C
#define ETHTX_DSTMAC_HREG  0x00000030
#define ETHTX_SRCPRT_REG   0x00000038
#define ETHTX_DSTPRT_REG   0x00000040
#define ETHTX_BYTCNT_LREG  0x00000048
#define ETHTX_BYTCNT_HREG  0x0000004C
#define ETHTX_BYTCNT_VREG  0x00000050
#define ETHTX_PCTCNT_REG   0x00000054
#define ETHTX_PCTCNT_VREG  0x00000058
#define ETHTX_ALLOW_REG    0x0000005C

MODULE_LICENSE("Dual MIT/GPL");
MODULE_AUTHOR
("John Mower - Susitronix, LLC");
MODULE_DESCRIPTION
("etharbtx - demo HLS ethernet arbiter");

#define DRIVER_NAME "etharbtx"
#define DRIVER_VERSION "1.0"

unsigned verbose = 0;
module_param(verbose, int, S_IRUGO);

static struct class *etharbtx_class;
static struct cdev   etharbtx_cdev;
static dev_t         etharbtx_devno;
static unsigned long etharbtx_mem_start;
static unsigned long etharbtx_mem_end;
static void __iomem *etharbtx_base_addr;
struct device *      etharbtx_device;
static atomic_t      etharbtx_accepting;
struct resource      etharbtx_res;
int                  etharbtx_running;

void inline etharbtx_allow(int allow)
{
  genericioHwWrite(etharbtx_base_addr + ETHTX_ALLOW_REG, allow ? 1 : 0);
  etharbtx_running = allow ? 1 : 0;
}

void inline etharbtx_config(struct etharbtx_cfg_t *configs)
{
  genericioHwWrite(etharbtx_base_addr + ETHTX_SRCIP_REG, configs->src_ip);
  genericioHwWrite(etharbtx_base_addr + ETHTX_DSTIP_REG, configs->dst_ip);
  genericioHwWrite(etharbtx_base_addr + ETHTX_SRCMAC_LREG, (uint32_t)configs->src_mac);
  genericioHwWrite(etharbtx_base_addr + ETHTX_SRCMAC_HREG, (uint32_t)(configs->src_mac >> 32));
  genericioHwWrite(etharbtx_base_addr + ETHTX_DSTMAC_LREG, (uint32_t)configs->dst_mac);
  genericioHwWrite(etharbtx_base_addr + ETHTX_DSTMAC_HREG, (uint32_t)(configs->dst_mac >> 32));
  genericioHwWrite(etharbtx_base_addr + ETHTX_SRCPRT_REG, configs->src_port);
  genericioHwWrite(etharbtx_base_addr + ETHTX_DSTPRT_REG, configs->dst_port);
}

void inline etharbtx_status(struct etharbtx_sts_t *statuss)
{
  statuss->byte_cnt = genericioHwRead(etharbtx_base_addr + ETHTX_BYTCNT_LREG);
  statuss->byte_cnt |= ((uint64_t)genericioHwRead(etharbtx_base_addr + ETHTX_BYTCNT_LREG)) << 32;
  statuss->packet_cnt = genericioHwRead(etharbtx_base_addr + ETHTX_PCTCNT_REG);
}

static int etharbtx_open(struct inode *inode, struct file *filp)
{
  if (verbose)
    printk(KERN_ALERT KBUILD_MODNAME " etharbtx_open\n");

  if (atomic_read(&etharbtx_accepting)) {
    printk(KERN_ERR KBUILD_MODNAME " already open\n");
    return -EMFILE;
  }

  atomic_set(&etharbtx_accepting, 1);

  etharbtx_allow(0);
  
  return 0;
}

static int etharbtx_release(struct inode *inode, struct file *filp)
{
  if (verbose)
    printk(KERN_ALERT KBUILD_MODNAME " etharbtx_release\n");
  
  etharbtx_allow(0);
  
  atomic_set(&etharbtx_accepting, 0);

  return 0;
}

static long etharbtx_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
  int ret = 0;
  
  if (verbose)
    printk(KERN_ALERT KBUILD_MODNAME " etharbtx_ioctl\n");
  
  switch (cmd) {
    
  case ETHARBTX_ALLOW:
    if (verbose)
      printk(KERN_ALERT KBUILD_MODNAME " ETHARBTX_ALLOW\n");

    int allowed;
    copy_from_user(&allowed, (int *)arg, sizeof(int));

    etharbtx_allow(allowed); 
    break;

  case ETHARBTX_CFG:
    if (verbose)
      printk(KERN_ALERT KBUILD_MODNAME " ETHARBTX_CFG\n");

    if (etharbtx_running) {
      if (verbose)
	printk(KERN_ALERT KBUILD_MODNAME " ioctl failed, etharbtx running\n");

      ret = -EBUSY;
      goto returnp;
    }
    
    struct etharbtx_cfg_t configs;

    copy_from_user(&configs, (struct etharbtx_cfg_t *)arg, sizeof(struct etharbtx_cfg_t));

    etharbtx_config(&configs);
    
    break;

  case ETHARBTX_STS:
    if (verbose)
      printk(KERN_ALERT KBUILD_MODNAME " ETHARBTX_STS\n");

    if (etharbtx_running) {
      if (verbose)
	printk(KERN_ALERT KBUILD_MODNAME " ioctl failed, etharbtx running\n");

      ret = -EBUSY;
      goto returnp;
    }
    
    struct etharbtx_sts_t statuss;

    etharbtx_status(&statuss);

    copy_to_user((struct etharbtx_sts_t *)arg, &statuss, sizeof(struct etharbtx_sts_t));
    
    break;

  default:
    printk(KERN_ERR KBUILD_MODNAME " invalid ioctl\n");
    ret = -EINVAL;

    break;
  }

returnp:
  return ret;
}

static const struct file_operations etharbtx_fops = {
  .owner          = THIS_MODULE,
  .open           = etharbtx_open,
  .release        = etharbtx_release,
  .unlocked_ioctl = etharbtx_ioctl,
};



static int etharbtx_probe(struct platform_device *pdev)
{
  struct resource *r_mem; 
  struct device *dev = &pdev->dev;
  etharbtx_device = &pdev->dev;

  int rc = 0;
    
  if (verbose)
    printk(KERN_ALERT KBUILD_MODNAME " etharbtx_probe\n");

  printk(KERN_ALERT KBUILD_MODNAME " driver version %s", DRIVER_VERSION);

  r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  if (!r_mem) {
    printk(KERN_ERR KBUILD_MODNAME " invalid address\n");
    return -ENODEV;
  }

  etharbtx_mem_start = r_mem->start;
  etharbtx_mem_end = r_mem->end;
  
  if (!request_mem_region(etharbtx_mem_start,
			  etharbtx_mem_end - etharbtx_mem_start + 1,
			  DRIVER_NAME)) {
    printk(KERN_ERR KBUILD_MODNAME " Couldn't lock memory region at %p\n",
	   (void *)etharbtx_mem_start);
    rc = -EBUSY;
    goto error1;
  }

  etharbtx_base_addr = ioremap(etharbtx_mem_start, etharbtx_mem_end - etharbtx_mem_start + 1);
  if (!etharbtx_base_addr) {
    printk(KERN_ERR KBUILD_MODNAME " Could not allocate iomem\n");
    rc = -EIO;
    goto error2;
  }

  if (verbose) {
    printk(KERN_ALERT KBUILD_MODNAME " memstart 0x%016x\n", r_mem->start);
    printk(KERN_ALERT KBUILD_MODNAME " memend   0x%016x\n", r_mem->end);
    printk(KERN_ALERT KBUILD_MODNAME " physical 0x%016x\n", etharbtx_base_addr);
  }

  if (verbose)
    printk(KERN_ALERT KBUILD_MODNAME " dev initialized\n");
  
  return 0;

error2:
  release_mem_region(etharbtx_mem_start, etharbtx_mem_end - etharbtx_mem_start + 1);
error1:
  dev_set_drvdata(dev, NULL);
  return rc;
}

static int etharbtx_remove(struct platform_device *pdev)
{
  if (verbose)
    printk(KERN_ALERT KBUILD_MODNAME " etharbtx_remove\n");

  struct device *dev = &pdev->dev;
  struct etharbtx_local *lp = dev_get_drvdata(dev);
  release_mem_region(etharbtx_mem_start, etharbtx_mem_end - etharbtx_mem_start + 1);
  dev_set_drvdata(dev, NULL);

  return 0;
}

static struct of_device_id etharbtx_of_match[] = {
  { .compatible = "susi,etharbtx", },
  { /* end of list */ },
};
MODULE_DEVICE_TABLE(of, etharbtx_of_match);

static struct platform_driver etharbtx_driver = {
  .driver = {
    .name = DRIVER_NAME,
    .owner = THIS_MODULE,
    .of_match_table	= etharbtx_of_match,
  },
  .probe		= etharbtx_probe,
  .remove		= etharbtx_remove,
};



static int __init etharbtx_init(void)
{
  if (verbose)
    printk(KERN_ALERT KBUILD_MODNAME " etharbtx_init\n");

  if (alloc_chrdev_region(&etharbtx_devno, 0, 1, DRIVER_NAME) < 0) {
    printk(KERN_ERR KBUILD_MODNAME " alloc_chrdev_region failed\n");
    return -1;
  }
  
  if ((etharbtx_class = class_create(THIS_MODULE, DRIVER_NAME)) == NULL) {
    printk(KERN_ERR KBUILD_MODNAME " class_create failed\n");
    goto INITERROR0;
  }

  if (NULL == device_create(etharbtx_class, NULL, etharbtx_devno, NULL, DRIVER_NAME)) {
    printk(KERN_ERR KBUILD_MODNAME " device_create failed\n");
    goto INITERROR1;
  }

  cdev_init(&etharbtx_cdev, &etharbtx_fops);
  if (cdev_add(&etharbtx_cdev, etharbtx_devno, 1) == -1) {
    printk(KERN_ERR KBUILD_MODNAME "cdev_add failed\n");
    goto INITERROR2;
  }
  
  return platform_driver_register(&etharbtx_driver);

 INITERROR2:
  device_destroy(etharbtx_class, etharbtx_devno);
 INITERROR1:
  class_destroy(etharbtx_class);
 INITERROR0:
  unregister_chrdev_region(etharbtx_devno, 1);
  return -1;  
}

static void __exit etharbtx_exit(void)
{
  device_destroy(etharbtx_class, etharbtx_devno);
  class_destroy(etharbtx_class);
  class_destroy(etharbtx_class);

  platform_driver_unregister(&etharbtx_driver);
  if (verbose)
    printk(KERN_ALERT KBUILD_MODNAME " etharbtx_exit\n");
}

module_init(etharbtx_init);
module_exit(etharbtx_exit);
